GNode
===========
<pre>
GNode reads <a href="https://en.wikipedia.org/wiki/G-code">gcode</a> files and simulates the operation of a <a href="https://en.wikipedia.org/wiki/CNC_router">CNC machine</a> or <a href="https://www.merriam-webster.com/dictionary/3D%20printer">3D printer.</a>

GNode was created using a voxel game engine called <a href="https://www.minetest.net/">Minetest</a>.

A stand-alone version of GNode can be downloaded here: <a href="https://github.com/Droog71/gnode">stand-alone download</a>
To run GNode, simply extract the contents of the downloaded file
and run start.bat (windows) or start.sh (linux).

If you already have the Minetest game engine installed and would
like to install GNode inside of Minetest, you can
simply clone this repository in the Minetest games directory.
More information is available here: <a href="https://wiki.minetest.net/Games#Installing_games">'Installing games in Minetest'</a>

Some example gcode files are provided.
Additional files can be placed in the directory 'mods/gnode/gcode'.
If the file names are added to files.json in this directory, a button will be added to the GUI for that file.
Otherwise the file can be used via commands.

Available commands are as follows:

'/cut file_name': Starts a cutting job for the given file name.
'/print file_name': Starts a printing job for the given file name.
'/pause': Pauses the current job.
'/resume': Resumes a paused job.
'/stop': Stops the current job.
'/output': Toggles the display of job info.
'/paint_color <number>': Changes the paint brush color. Options are 0 to 255. Zero is the default color.

The <a href="https://archive.vectric.com/support/intro-to-cnc/workflow.html">workflow</a> used to create gcode files for GNode is the same as if you were using a real CNC router or 3D printer.

<h1>Engraving</h1>
<img src="https://www.dropbox.com/s/jou3h8ck9l6jr6f/cnc_face.png?raw=true" alt="GNode"><img src="https://www.dropbox.com/s/9hxmzxsbjmvlxfw/cnc_rabbit.png?raw=true" alt="GNode">
In this engraving example, <a href="https://inkscape.org/">inkscape</a> was used to prepare the <a href="https://publicdomainvectors.org/en/free-clipart/Dog-portrait-vector-drawing/12093.html">.svg file.</a>
A tutorial for this process can be found here: <a href="https://www.youtube.com/watch?v=bbe56S_O-uI">https://www.youtube.com/watch?v=bbe56S_O-uI</a>
The gcode file was then created using <a href="http://jscut.org/">jscut</a>.
A good tutorial for jscut can be found here: <a href="https://cncphilosophy.com/svg-to-g-code/">https://cncphilosophy.com/svg-to-g-code/</a>
Software such as <a href="https://github.com/Denvi/Candle">Candle</a> can also be used to preview the results.
The working area was defined as 300mm by 180mm with a depth of 3mm and a center point of 0,0.
In GNode, this means the engraving will take place at (0,0,0), remain within an area of 300x180
nodes and cut 3 nodes deep into the surface.


<img src="https://www.dropbox.com/s/8jso5kp23pgosux/cnc_dog.gif?raw=true" alt="GNode">
Simulated CNC wood engraving.

<h1>3D Printing</h1>
<img src="https://www.dropbox.com/s/1fu7eyc7mewm4om/table.png?raw=true" alt="GNode"><img src="https://www.dropbox.com/s/0tcgy3zk3lkp4ut/aliens.png?raw=true" alt="GNode">
In this 3D printing example, slicing software such as <a href="https://slic3r.org/">Slic3r</a> 
is used to create a gcode file by slicing the given <a href="https://cdn.thingiverse.com/assets/6c/be/d4/71/d4/benchy_voxel.stl">.stl file</a>.

Some tools such as <a href="https://github.com/Uberi/Minetest-WorldEdit">worldedit</a> and <a href="https://github.com/minetest-mods/mapfix">mapfix</a> are included with GNode for the
purpose of modifying or moving objects around after the job is finished.

The <a href="https://github.com/minetest-mods/skybox">skybox mod</a> is included as well along with 2 new skyboxes.
This inclusion is primarily to provide backdrops for your 3D printed objects.



<img src="https://www.dropbox.com/s/0tssub7ww5pcyhj/VoxelizerByQuantumZ.png?raw=true" alt="GNode"><img src="https://www.dropbox.com/s/mj42k9kg07kz7su/boat_print.gif?raw=true" alt="GNode">
Simulated 3D printing.

<h1>Painting</h1>
<img src="https://www.dropbox.com/s/usolz1i5xdez9em/lucy_cat.png?raw=true" alt="GNode"><img src="https://www.dropbox.com/s/2m0qo4gxjom5rqg/painted_cat.png?raw=true" alt="GNode">
Painting a 3D printed cat in Minetest.



Objects you create can be painted. The paint color can be selected by pressing 
I and clicking the 'Paint Color' button or by using the '/paint_color' command.
<img src="https://www.dropbox.com/s/wrzvoljn7xtclfg/paint_gui.png?raw=true" alt="GNode">


To paint an area, left click a node. This marks one corner of a bounding box.
Left click another node. This marks the opposite corner of the bounding box.
These nodes must be made of the same material, ie: plastic or wood.
Once you have selected an area, right click and the entire area will be painted
with the color you have selected.
<img src="https://www.dropbox.com/s/d6i6p2gs7fwd8rs/paint.gif?raw=true" alt="GNode">

<h1>Credits</h1>
CNC art
-------
rabbit: CC0, <a href=https://publicdomainvectors.org/en/free-clipart/Rabbit/35622.html>https://publicdomainvectors.org/en/free-clipart/Rabbit/35622.html</a>
dog: CC0, <a href=https://publicdomainvectors.org/en/free-clipart/Dog-portrait-vector-drawing/12093.html>https://publicdomainvectors.org/en/free-clipart/Dog-portrait-vector-drawing/12093.html</a>
face: CC0, <a href=https://publicdomainvectors.org/en/free-clipart/Vector-graphics-of-mans-normal-face/28404.html>https://publicdomainvectors.org/en/free-clipart/Vector-graphics-of-mans-normal-face/28404.html</a>

3D printer art
--------------
cat: GPLv2, <a href=https://www.thingiverse.com/thing:24255/files>https://www.thingiverse.com/thing:24255/files</a>
boat: CC BY 4.0, <a href=https://www.thingiverse.com/thing:2763479/files>https://www.thingiverse.com/thing:2763479/files</a>
cube: CC0, <a href=https://www.thingiverse.com/thing:38108/files>https://www.thingiverse.com/thing:38108/files</a>
bunny: CC BY 4.0, <a href=https://www.thingiverse.com/thing:2763479/files>https://www.thingiverse.com/thing:2763479/files</a>

Color Palette
-------------
CC BY-SA 4.0, <a href=https://stackoverflow.com/a/33295456>https://stackoverflow.com/a/33295456</a>

Paint Brush
-----------
CC0, <a href=https://publicdomainvectors.org/en/free-clipart/Paint-brush-vector-drawing/15461.html>https://publicdomainvectors.org/en/free-clipart/Paint-brush-vector-drawing/15461.html</a>

Icon
----
CC0, <a href=https://openclipart.org/detail/160057/machine-controlblue>https://openclipart.org/detail/160057/machine-controlblue</a>

Menu Background
---------------
CC0, <a href=https://commons.wikimedia.org/wiki/File:Printer_3D_Bioprinting_Solutions.jpg>https://commons.wikimedia.org/wiki/File:Printer_3D_Bioprinting_Solutions.jpg</a>

Interior Skybox
---------------
Walls, CC0, <a href=https://ambientcg.com/view?id=Bricks059>https://ambientcg.com/view?id=Bricks059</a>
Ceiling, CC0, <a href=https://ambientcg.com/view?id=OfficeCeiling001>https://ambientcg.com/view?id=OfficeCeiling001</a>
Floor, CC0, <a href=https://ambientcg.com/view?id=Tiles078>https://ambientcg.com/view?id=Tiles078</a>

Skybox Mod
----------
* Code: LGPLv2.1

Copyright (C) 2017 - Auke Kok <sofar@foo-projects.org>

Contributors:	
    sofar
    LoneWolfHT
    auouymous
    Maverick2797

* Artwork (textures):

SkyboxSet by Heiko Irrgang ( http://gamvas.com ) is licensed under
the Creative Commons Attribution-ShareAlike 3.0 Unported License.
Based on a work at http://93i.de.

Mapfix Mod
----------
Made by wsor.
License: GPLv3

Worldedit Mod
-------------
Copyright (c) 2012 sfan5, Anthony Zhang (Uberi/Temperest), and Brett O'Donnell (cornernote).
License: AGPL-3.0

Contributors:
	Alexander Weber
	ANAND
	beyondlimits
	Carter Kolwey
	cornernote
	Cy
	Daniel Sosa
	electricface
	est31
	Eugen Wesseloh
	h3ndrik
	HybridDog
	Isidor Zeuner
	Jean-Patrick Guerrero
	Joseph Pickard
	kaeza
	kilbith
	KodexKy
	Kyle
	MT-Modder
	Niwla23
	Panquesito7
	Pedro Gimeno
	Rui
	Sebastien Ponce
	sfan5
	ShadowNinja
	shivajiva101
	spillz
	Starbeamrainbowlabs
	TalkLounge
	tenplus1
	Uberi/Temperest
	Wuzzy
</pre>
