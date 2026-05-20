package funkin.util.plugins;

import flixel.FlxBasic;
import funkin.Preferences;

/**
 * A plugin which adds functionality to press `Ins` to immediately perform memory garbage collection.
 * Also performs periodic GC when low-end mode is enabled.
 */
@:nullSafety
class MemoryGCPlugin extends FlxBasic
{
  /**
   * Interval in seconds between automatic GC cycles in low-end mode.
   */
  static final LOW_END_GC_INTERVAL:Float = 30.0;

  var gcTimer:Float = 0.0;

  public function new()
  {
    super();
  }

  public static function initialize():Void
  {
    FlxG.plugins.addPlugin(new MemoryGCPlugin());
  }

  public override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    if (FlxG.keys.justPressed.INSERT)
    {
      var perf = new funkin.util.logging.Perf();
      funkin.util.MemoryUtil.collect(true);
      perf.print();
    }

    // Periodic GC for low-end mode to prevent memory fragmentation
    if (Preferences.lowEndMode)
    {
      gcTimer += elapsed;
      if (gcTimer >= LOW_END_GC_INTERVAL)
      {
        gcTimer = 0.0;
        funkin.util.MemoryUtil.collect(false); // Non-blocking GC
      }
    }
  }

  public override function destroy():Void
  {
    super.destroy();
  }
}
