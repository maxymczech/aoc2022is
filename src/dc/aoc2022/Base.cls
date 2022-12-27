Class dc.aoc2022.Base Extends %RegisteredObject
{

Parameter Folder = "D:\work\_competitions\adventofcode\2022-intersystems\data\";

// Parameter Folder = "/usr/irissys/mgr/user/";

ClassMethod GetInput(fn) As %Stream
{
    set fn=..#Folder_fn
    set stream = ##Class(%Stream.FileCharacter).%New()
    do stream.LinkToFile(fn)
    return stream
}

}
