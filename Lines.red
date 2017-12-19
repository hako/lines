Red [
	title: "Lines Clone"
	author: "Wesley Hill"
	version: 0.1
	needs: 'View
]

; JSON
#include %JSON.red

; Font Name
; Should be Johnston or NJFont, I know. But if you want Johnston, 
; Install NJFont and change this name.
; TODO: Add Change font feature.
tube_font: "Gill Sans"

; Setup Window
win: [title "Lines (TFL Checker)"
	; All black backdrop		
	backdrop black
	below left
	base 0x0 black
	origin 0x0
	space 0x0	
]

tube_colors: make map! [
	"dlr" 0.193.183
	"overground" 255.91.0
	"tram-tram" 46.107.217
	"circle" 255.210.36
	"district" 0.138.68
	"bakerloo" 184.89.6
	"central" 254.0.0
	"hammersmithandcity" 255.120.156
	"jubilee" 103.110.114
	"metropolitan" 158.33.173
	"northern" 0.0.0
	"piccadilly" 46.107.217
	"victoria" 38.160.226
	"waterlooandcity" 78.198.209
]

do [
	fetch-data: read http://app.getlin.es/status/current.json [
		GET  [
			Accept: "*/*"
			User-Agent: "Lines/2.7 (iPhone; iOS 9.0.2; Scale/2.00)"
			Accept-Language: "en-GB;q=1"
			Connection: "close"
		]
	]
	
	data: json/decode fetch-data
	data: data/lines
	
	append win [across]
	foreach d data [
	  name: d/name
	  id: d/id
	  color: select tube_colors id
	  message: d/message
	  status: d/icon
	
	; "Change colors for special cells"
	either any [
		 d/id == "hammersmithandcity"
		 d/id == "circle"
		 d/id == "waterlooandcity"
	]
	
	[
	  append win compose/deep [
			panel (color) 250x45 [below text (name) font-size: 14 font-color: 0.33.147 font-name: tube_font]
			cursor hand on-down [
				view [title (name)
					backdrop (color)
					below
					a: area 400x400 no-border (color) font [name: tube_font size: 11 color: 0.33.147]
					do [
						a/text: (d/message)
					]
				]
			]
		]
	]
	
	[
	  append win compose/deep [
			panel (color) 250x45 [below text (name) font-size: 14 font-color: white font-name: tube_font]
			cursor hand on-down [
				view [title (name)
					backdrop (color)
					below
					a: area 400x400 no-border (color)  font [name: tube_font size: 12 color: white]
					do [
						a/text: (d/message)
					]
				]
			]
		]
	]
	
	; "Change colors for cells that have alerts or icons."	
	switch d/icon [
		"alert" [	
			either any [
			 d/id == "hammersmithandcity"
			 d/id == "circle"
			 d/id == "waterlooandcity"
			] [
			  append win compose/deep [
				panel (color) [size 45x45] draw [
					fill-pen  0.33.147 line-width 0 circle 22x22 12
					pen 0.33.147
					fill-pen (color)
					box 21x24 23x15
					fill-pen (color) line-width 0 circle 22x28 2
				] return
			  ]	
			]
			
			[
			  append win compose/deep [
				panel (color) [size 45x45] draw [
					fill-pen  white line-width 0 circle 22x22 12
					pen (color)
					fill-pen (color)
					box 21x24 23x15
					fill-pen  (color) line-width 0 circle 22x28 2
				] return
			  ]		
			]
		]
		"check" [	
				either any [
				 d/id == "hammersmithandcity"
				 d/id == "circle"
				 d/id == "waterlooandcity"
				] [
				  append win compose/deep [
					panel (color) [size 45x45] draw [
						pen 0.33.147 line-width 2 circle 22x22 12
						pen 0.33.147
						fill-pen 0.33.147
						pen 0.33.147
						polygon 16x23 16x23 16x23 20x27 
						polygon 28x18 28x18 28x18 19x27
					] return
				  ]	
				]
				
				[
				  append win compose/deep [
					panel (color) [size 45x45] draw [
						pen white line-width 2 circle 22x22 12
						pen white
						fill-pen white
						pen white
						polygon 16x23 16x23 16x23 20x27 
						polygon 28x18 28x18 28x18 19x27
					] return
				  ]
				]
			]
	]

	  append win [below] 
	  append win [across]
	]
	
	
]

view/flags win [no-min]