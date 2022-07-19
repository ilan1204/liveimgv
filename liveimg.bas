B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.3
@EndOfDesignText@
Sub Class_Globals
	Private pnl As B4XView
	Private xui As XUI
	Private cnv As B4XCanvas
	Private livebmp1, livebmp2 As B4XBitmap
	Private vpW, vpH, linePosX As Float
	Private startMoving As Boolean
	Private touchDistance As Float = 10dip
	Private gapDistance As Float = 1dip
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(senderPnl As B4XView, x As Float, y As Float, width As Float, height As Float)
	pnl = xui.CreatePanel("pnl")
	senderPnl.AddView(pnl,x,y,width,height)	
	startMoving = False
	cnv.Initialize(pnl)
	vpW = width
	vpH = height
	linePosX = vpW/2
End Sub

Public Sub setImages(bmp1 As B4XBitmap, bmp2 As B4XBitmap)
	livebmp1 = bmp1
	livebmp2 = bmp2
	draw(True)
End Sub

Public Sub getSnapshot As B4XBitmap
	draw(False)
	Dim bmp As B4XBitmap = pnl.Snapshot
	draw(True)
	Return bmp
End Sub
 
Private Sub pnl_Touch (Action As Int, X As Float, Y As Float)
	Select Action
		Case 0
			startMoving =  distance(X,linePosX,vpH/2,Y) < touchDistance 
		Case 1
			startMoving = False
		Case 2
			If startMoving Then 
				linePosX = Max(gapDistance,Min(vpW-gapDistance,X))
				draw(True)
			End If
	End Select
End Sub

Private Sub draw(drawSplit As Boolean)
	cnv.ClearRect(cnv.TargetRect)
	cnv.DrawBitmap(livebmp1,getRect(0,0,vpW,vpH))
	Dim p As B4XPath
	p.Initialize(linePosX,0)
	p.LineTo(vpW,0)
	p.LineTo(vpW,vpH)
	p.LineTo(linePosX,vpH)
	p.LineTo(linePosX,0)
	cnv.ClipPath(p)
	cnv.DrawBitmap(livebmp2,getRect(0,0,vpW,vpH))
	cnv.RemoveClip
	If drawSplit Then drawSplitLine
	cnv.Invalidate
End Sub
 
Private Sub getRect(x As Float, y As Float, width As Float, height As Float) As B4XRect
	Dim r As B4XRect
	r.Initialize(x,y,x+width,y+height)
	Return r
End Sub

Private Sub drawSplitLine
	cnv.DrawLine(linePosX,0,linePosX,vpH,xui.Color_White,2dip)
	cnv.DrawCircle(linePosX,vpH/2,6dip,xui.Color_White,False,1dip)
End Sub

Private Sub distance(x1 As Float, x2 As Float, y1 As Float, y2 As Float) As Double
	Dim dX = x2 - x1 As Double
	Dim dY = y2 - y1 As Double
	Return Sqrt((dX * dX) + (dY * dY)) 'simple distance calculation
End Sub
