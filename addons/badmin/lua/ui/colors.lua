ui.col = {
	SUP 			= Color(77, 111, 255),
	Header 			= Color(18, 18, 18),
	Gradient 		= Color(85,85,85,200),
	Background 		= Color(10,10,10,155),
	Outline 		= Color(75,75,75,255),
	Hover 			= Color(160,160,160,75),


	Button 			= Color(18, 18, 18),
	ButtonHover 	= Color(220,220,220),
	ButtonRed 		= Color(240,0,0),
	ButtonGreen 	= Color(0,240,0),
	ButtonBlack 	= Color(25,25,25),
	Close 			= Color(235,235,235),
	CloseBackground = Color(215, 0, 50),
	CloseHovered 	= Color(235, 0, 70),


	TransGrey155 	= Color(100,100,100,155),
	TransWhite50 	= Color(255,255,255,50),
	TransWhite100 	= Color(255,255,255,100),
	OffWhite 		= Color(200,200,200),
	Grey 			= Color(100,100,100),
	LightGrey		= Color(150,150,150),
	FlatBlack 		= Color(45,45,45),
	Black 			= Color(0,0,0),
	White 			= Color(255,255,255),
	Blue 			= Color(0, 50, 200),
	Red 			= Color(235,10,10),
	DarkRed			= Color(200,10,10),
	Green 			= Color(10,235,10),
	DarkGreen 		= Color(0, 153, 51),
	Orange 			= Color(245,120,0),
	Yellow 			= Color(255,255,51),
	Gold 			= Color(212,175,55),
	Purple 			= Color(147,112,219),
	Pink 			= Color(255,105,180),
	Brown 			= Color(139,69,19),
}

if (CLIENT) then
	include 'theme.lua' -- lua refresh
end