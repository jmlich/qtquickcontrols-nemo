import QtQuick.Window 2.2
import QtQuick 2.6
import QtQuick.Controls

//@todo
//import Nemo.Configuration 1.0

Rectangle {
    id: backgroundWallpaper
    anchors.fill: parent
    visible: width != root.width || height != root.height || wallpaperSource.value == ""
    color: Theme.backgroundColor


    /*ConfigurationValue {
        id: wallpaperSource
        key: "/home/glacier/homeScreen/wallpaperImage"
        defaultValue: ""
    }*/
}
