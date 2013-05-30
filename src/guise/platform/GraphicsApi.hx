package guise.platform;

class GraphicsApi{}


#if nme
typedef IGraphicsData = nme.display.IGraphicsData;

typedef GraphicsStroke = nme.display.GraphicsStroke;
typedef GraphicsSolidFill = nme.display.GraphicsSolidFill;
typedef GraphicsBitmapFill = nme.display.GraphicsBitmapFill;
typedef GraphicsEndFill = nme.display.GraphicsEndFill;
typedef GraphicsGradientFill = nme.display.GraphicsGradientFill;
typedef GraphicsPath = nme.display.GraphicsPath;
typedef GraphicsPathCommand = nme.display.GraphicsPathCommand;
typedef GraphicsPathWinding = nme.display.GraphicsPathWinding;
typedef CapsStyle = nme.display.CapsStyle;
typedef JointStyle = nme.display.JointStyle;
typedef InterpolationMethod = nme.display.InterpolationMethod;
typedef LineScaleMode = nme.display.LineScaleMode;
typedef GradientType = nme.display.GradientType;

typedef GraphArray<T> = nme.Vector<T>;
#end