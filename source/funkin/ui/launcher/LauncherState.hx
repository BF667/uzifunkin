package funkin.ui.launcher;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import funkin.graphics.FunkinSprite;
import funkin.ui.MusicBeatState;
import funkin.ui.title.TitleState;
import funkin.audio.FunkinSound;
import funkin.Paths;
import funkin.Preferences;
#if FEATURE_CHART_EDITOR
import funkin.ui.debug.charting.ChartEditorState;
#end
#if FEATURE_POLYMOD_MODS
import funkin.modding.PolymodHandler;
#end

/**
 * The Launcher State is the first screen the user sees when starting FNF: Uzi Funkin Engine.
 * It provides two main modes:
 * - Gameplay Mode: Play the game normally (Story Mode, Freeplay, etc.)
 * - Modding Mode: Access the Chart Editor, Stage Editor, and mod management tools
 *
 * This launcher also serves as a hub for basic mod management,
 * including importing mods and configuring mod settings.
 */
class LauncherState extends MusicBeatState
{
  // Visual elements
  var bg:FunkinSprite;
  var logo:FunkinSprite;
  var titleText:FlxText;
  var subtitleText:FlxText;
  var versionText:FlxText;

  // Buttons
  var gameplayButton:LauncherButton;
  var moddingButton:LauncherButton;

  // Mod management section
  var modInfoText:FlxText;
  var importModHint:FlxText;

  // Selected option
  var selectedOption:Int = 0;
  var options:Array<LauncherButton> = [];

  // Transition flag
  var transitioning:Bool = false;

  override public function create():Void
  {
    super.create();

    persistentUpdate = true;

    // Background
    bg = new FunkinSprite(-1).makeSolidColor(FlxG.width + 2, FlxG.height, FlxColor.fromRGB(15, 10, 30));
    bg.screenCenter();
    add(bg);

    // Decorative gradient overlay
    var gradientOverlay:FunkinSprite = new FunkinSprite(-1).makeSolidColor(FlxG.width + 2, FlxG.height, FlxColor.fromRGB(40, 20, 80));
    gradientOverlay.screenCenter();
    gradientOverlay.alpha = 0.3;
    add(gradientOverlay);

    // Logo / Title area
    logo = new FunkinSprite(0, 40);
    logo.frames = Paths.getSparrowAtlas('logoBumpin');
    logo.animation.addByPrefix('bump', 'logo bumpin', 24);
    logo.animation.play('bump');
    logo.setGraphicSize(Std.int(logo.width * 0.5));
    logo.updateHitbox();
    logo.screenCenter(X);
    logo.x -= 200;
    add(logo);

    // Title text
    titleText = new FlxText(0, 60, 0, "FNF: UZI FUNKIN ENGINE", 36);
    titleText.setFormat(Paths.font('vcr.ttf'), 36, FlxColor.fromRGB(255, 100, 255), CENTER);
    titleText.screenCenter(X);
    titleText.x += 120;
    add(titleText);

    // Subtitle
    subtitleText = new FlxText(0, 105, 0, "Low-End Optimized Engine", 18);
    subtitleText.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.fromRGB(180, 140, 255), CENTER);
    subtitleText.screenCenter(X);
    subtitleText.x += 120;
    add(subtitleText);

    // Version text
    versionText = new FlxText(0, 130, 0, funkin.util.Constants.VERSION, 14);
    versionText.setFormat(Paths.font('vcr.ttf'), 14, FlxColor.GRAY, CENTER);
    versionText.screenCenter(X);
    versionText.x += 120;
    add(versionText);

    // Mode selection buttons
    gameplayButton = new LauncherButton(0, 250, "GAMEPLAY MODE", "Play Story Mode, Freeplay, and more!", FlxColor.fromRGB(80, 200, 120));
    gameplayButton.screenCenter(X);
    add(gameplayButton);
    options.push(gameplayButton);

    moddingButton = new LauncherButton(0, 400, "MODDING MODE", "Chart Editor, Stage Editor, Import Mods", FlxColor.fromRGB(200, 100, 255));
    moddingButton.screenCenter(X);
    add(moddingButton);
    options.push(moddingButton);

    // Mod info section
    var enabledModsCount:Int = getEnabledModCount();
    modInfoText = new FlxText(0, 530, FlxG.width - 40, 'Mods Loaded: $enabledModsCount', 16);
    modInfoText.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.fromRGB(150, 150, 200), CENTER);
    modInfoText.screenCenter(X);
    add(modInfoText);

    #if FEATURE_FILE_DROP
    importModHint = new FlxText(0, 560, FlxG.width - 40, "Drag and drop a .zip mod file onto the window to import", 13);
    importModHint.setFormat(Paths.font('vcr.ttf'), 13, FlxColor.fromRGB(120, 120, 160), CENTER);
    importModHint.screenCenter(X);
    add(importModHint);

    // Set up file drop handler for mod importing
    FlxG.stage.window.onDropFile.add(handleFileDrop);
    #else
    importModHint = new FlxText(0, 560, FlxG.width - 40, "Place mods in the /mods folder to load them", 13);
    importModHint.setFormat(Paths.font('vcr.ttf'), 13, FlxColor.fromRGB(120, 120, 160), CENTER);
    importModHint.screenCenter(X);
    add(importModHint);
    #end

    // Low-end mode indicator
    if (Preferences.lowEndMode)
    {
      var lowEndBadge:FlxText = new FlxText(10, FlxG.height - 30, 0, "[LOW-END MODE ACTIVE]", 12);
      lowEndBadge.setFormat(Paths.font('vcr.ttf'), 12, FlxColor.fromRGB(255, 200, 50), LEFT);
      add(lowEndBadge);
    }

    // Select first option
    updateSelection();

    // Fade in
    FlxG.camera.fade(FlxColor.BLACK, 1.0, true);

    // Play menu music if not already playing
    if (FlxG.sound.music == null || !FlxG.sound.music.playing)
    {
      FunkinSound.playMusic('freakyMenu', {
        startingVolume: 0.0,
        overrideExisting: true,
        restartTrack: false,
        persist: true
      });
      FlxG.sound.music.fadeIn(2.0, 0.0, 0.7);
    }
  }

  function getEnabledModCount():Int
  {
    #if FEATURE_POLYMOD_MODS
    var mods = funkin.save.Save.instance?.enabledModDirs?.value;
    if (mods != null) return mods.length;
    #end
    return 0;
  }

  #if FEATURE_FILE_DROP
  function handleFileDrop(path:String, state:String, x:Float, y:Float):Void
  {
    if (transitioning) return;
    trace('File dropped: $path');

    if (path.endsWith('.zip'))
    {
      try
      {
        var modName:String = haxe.io.Path.withoutDirectory(haxe.io.Path.withoutExtension(path));

        if (!sys.FileSystem.exists('./mods')) sys.FileSystem.createDirectory('./mods');

        // Copy the zip to the mods directory
        sys.io.File.copy(path, './mods/$modName.zip');

        // Refresh mod list
        PolymodHandler.loadAllMods();

        var enabledModsCount:Int = getEnabledModCount();
        modInfoText.text = 'Mods Loaded: $enabledModsCount (Imported: $modName)';
        modInfoText.color = FlxColor.fromRGB(100, 255, 100);

        new FlxTimer().start(3.0, function(_)
        {
          modInfoText.color = FlxColor.fromRGB(150, 150, 200);
          modInfoText.text = 'Mods Loaded: $enabledModsCount';
        });
      }
      catch (e:Dynamic)
      {
        trace('Error importing mod: $e');
        modInfoText.text = 'Error importing mod: $e';
        modInfoText.color = FlxColor.RED;
      }
    }
    else
    {
      modInfoText.text = 'Only .zip mod files are supported';
      modInfoText.color = FlxColor.fromRGB(255, 150, 50);

      new FlxTimer().start(3.0, function(_)
      {
        var enabledModsCount:Int = getEnabledModCount();
        modInfoText.color = FlxColor.fromRGB(150, 150, 200);
        modInfoText.text = 'Mods Loaded: $enabledModsCount';
      });
    }
  }
  #end

  override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (transitioning) return;

    // Navigate between options
    if (controls.UI_UP_P)
    {
      selectedOption = (selectedOption - 1 + options.length) % options.length;
      updateSelection();
      FunkinSound.playOnce(Paths.sound('scrollMenu'), 0.4);
    }
    if (controls.UI_DOWN_P)
    {
      selectedOption = (selectedOption + 1) % options.length;
      updateSelection();
      FunkinSound.playOnce(Paths.sound('scrollMenu'), 0.4);
    }

    // Confirm selection
    if (controls.ACCEPT)
    {
      selectOption(selectedOption);
    }

    // Mouse/touch support - check hover and click
    for (i => button in options)
    {
      if (FlxG.mouse.justMoved && button.isMouseOver())
      {
        if (selectedOption != i)
        {
          selectedOption = i;
          updateSelection();
        }
      }
      if (FlxG.mouse.justPressed && button.isMouseOver())
      {
        selectOption(i);
      }
    }
  }

  function updateSelection():Void
  {
    for (i => button in options)
    {
      button.setSelected(i == selectedOption);
    }
  }

  function selectOption(index:Int):Void
  {
    if (transitioning) return;
    transitioning = true;

    FunkinSound.playOnce(Paths.sound('confirmMenu'), 0.7);

    switch (index)
    {
      case 0: // Gameplay Mode
        FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function()
        {
          FlxTransitionableState.skipNextTransIn = true;
          FlxG.switchState(() -> new TitleState());
        });

      case 1: // Modding Mode
        FlxG.camera.fade(FlxColor.BLACK, 0.8, false, function()
        {
          #if FEATURE_CHART_EDITOR
          FlxG.switchState(() -> new ChartEditorState());
          #else
          // Fallback to title if no chart editor
          FlxTransitionableState.skipNextTransIn = true;
          FlxG.switchState(() -> new TitleState());
          #end
        });
    }
  }

  override function beatHit():Bool
  {
    if (!super.beatHit()) return false;

    // Subtle logo bump on beat
    if (logo != null && logo.animation != null)
    {
      logo.animation.play('bump', true);
    }

    return true;
  }

  override function destroy():Void
  {
    #if FEATURE_FILE_DROP
    // Clean up file drop handler
    if (FlxG.stage != null && FlxG.stage.window != null)
    {
      FlxG.stage.window.onDropFile.remove(handleFileDrop);
    }
    #end

    super.destroy();
  }
}

/**
 * A custom button class for the launcher.
 */
class LauncherButton extends FlxGroup
{
  var bg:FunkinSprite;
  var label:FlxText;
  var description:FlxText;
  var glow:FunkinSprite;
  var accentColor:FlxColor;
  var _selected:Bool = false;

  public function new(x:Float, y:Float, labelText:String, descText:String, color:FlxColor)
  {
    super();

    accentColor = color;

    // Glow effect (behind the button)
    glow = new FunkinSprite(x - 8, y - 8).makeSolidColor(516, 136, color);
    glow.alpha = 0;
    add(glow);

    // Button background
    bg = new FunkinSprite(x, y).makeSolidColor(500, 120, FlxColor.fromRGB(25, 20, 45));
    add(bg);

    // Label text
    label = new FlxText(x + 20, y + 15, 460, labelText, 28);
    label.setFormat(Paths.font('vcr.ttf'), 28, color, LEFT);
    add(label);

    // Description text
    description = new FlxText(x + 20, y + 60, 460, descText, 14);
    description.setFormat(Paths.font('vcr.ttf'), 14, FlxColor.fromRGB(160, 160, 190), LEFT);
    add(description);
  }

  public function setSelected(selected:Bool):Void
  {
    _selected = selected;

    if (selected)
    {
      bg.color = FlxColor.fromRGB(40, 30, 65);
      glow.alpha = 0.3;
      label.scale.set(1.05, 1.05);
    }
    else
    {
      bg.color = FlxColor.fromRGB(25, 20, 45);
      glow.alpha = 0;
      label.scale.set(1.0, 1.0);
    }
  }

  public function isMouseOver():Bool
  {
    var mouseX:Float = FlxG.mouse.screenX;
    var mouseY:Float = FlxG.mouse.screenY;

    return mouseX >= bg.x && mouseX <= bg.x + bg.width && mouseY >= bg.y && mouseY <= bg.y + bg.height;
  }
}
