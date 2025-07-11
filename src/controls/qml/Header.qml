/*
 * Copyright (C) 2018-2023 Chupligin Sergey <neochapay@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

import QtQuick
import QtQuick.Controls
import Nemo

Item {
    id: header

    //TODO: Add logic/animations to handle dynamic change of tools and drawer levels in the same page

    //make sure the header is aligned properly
    Binding on y {
        restoreMode: Binding.RestoreBinding
        when: !appWindow.isUiPortrait
        value: 0
    }

    Binding on x {
        restoreMode: Binding.RestoreBinding
        when: appWindow.isUiPortrait
        value: 0
    }

    //Since the header drawer behaves differently in portrait/landscape modes
    //we close the drawer when the UI rotates
    Connections {
        target: appWindow
        function onIsUiPortraitChanged() {
            closeDrawer()
        }
    }

    //Handle portrait/landscape orientation layout changes
    //Using states is better than having "anchors.left: appWindow.isUiPortrait ? portraitanchor : landscapeanchor"
    //because in the latter way when isUiPortrait changes, the order of reevaluation of the anchors bindings
    //(hence the resulting layout) cannot be predicted. Using States we avoid that source of issues
    states: [
        State {
            id: portraitState
            when: appWindow && appWindow.isUiPortrait
            AnchorChanges {
                target: toolBarRect;
                anchors.left: header.left
            }
            AnchorChanges {
                target: drawerContainer;
                anchors.top: undefined
                anchors.bottom: toolBarRect.top
                anchors.left: header.left
                anchors.right: header.right
            }
            AnchorChanges {
                target: drawer;
                anchors.right: undefined
                anchors.bottom: drawerContainer.bottom
                anchors.verticalCenter: undefined
                anchors.horizontalCenter: drawerContainer.horizontalCenter
            }
            //having width/height as PropertyChanges avoids creating binding loops
            PropertyChanges {
                target: header
                width: parent.width
                //the height of the drawer in portrait is limited by the size of the shorter edge of the screen
                height: toolBarRect.height + drawer.height
            }
            //remember: the PropertyChanges handle bindings by default, unless "explicit: true" is set
            PropertyChanges {
                target: toolBarRect
                width: parent.width
                height: Theme.itemHeightLarge
            }
        },
        State {
            id: landscapeState
            when: appWindow && !appWindow.isUiPortrait
            AnchorChanges {
                target: toolBarRect;
                anchors.left: undefined
            }
            AnchorChanges {
                target: drawerContainer;
                anchors.top: header.top
                anchors.bottom: header.bottom
                anchors.left: undefined
                anchors.right: toolBarRect.left
            }
            AnchorChanges {
                target: drawer;
                anchors.right: drawerContainer.right
                anchors.bottom: undefined
                anchors.verticalCenter: drawerContainer.verticalCenter
                anchors.horizontalCenter: undefined
            }
            PropertyChanges {
                target: header
                width: toolBarRect.width + drawer.width
                height: parent.height
            }
            PropertyChanges {
                target: toolBarRect
                width: Theme.itemHeightLarge
                height: parent.height
            }
        }
    ]

    //this is the value that will be used by toolBarContainer
    //please pretty please don't turn it into an alias to toolBarContainer.data,
    //because in that way you won't get change signals (.data doesn't have NOTIFY
    //and is a Q_PRIVATE_PROPERTY) and you won't be able to access the toolbarLayout
    //directly. So -> not a good idea :)
    property variant toolBarLayout
    function closeDrawer() {
        x = Qt.binding(function() { return appWindow.isUiPortrait ? 0 : -drawer.width})
        y = Qt.binding(function() { return appWindow.isUiPortrait ? -drawer.height : 0})
    }

    property double speedBumpThreshold: 3/5
    property int closedY: - drawer.height
    property int closedX: - drawer.width
    property int closedCoord: appWindow.isUiPortrait ? closedY : closedX

    //those properties are initialized when the header is created
    //(See ApplicationWindow source)
    property StackView stackView
    property variant appWindow

    //used for manual type checking when looking for items of type Header from other QML elements
    property bool __isNemoHeader

    //propagate header reference to headerTools which have the "header" property
    //used by the headerTools to know when it should display the back button
    //(i.e. to get header.stackView.depth value)
    Connections {
        target: stackView
        function onCurrentItemChanged() {
            if (changeToolsLayoutAnim.running) {
                changeToolsLayoutAnim.complete()
            }
            changeToolsLayoutAnim.start()
        }
        //Close drawer if a page transition is starting
        function onBusyChanged() {
            if (stackView.busy) closeDrawer()
        }
    }

    function propagateHeaderReference() {
        if (toolBarLayout && toolBarLayout.hasOwnProperty("header")) {
            toolBarLayout.header = toolBar
        }
    }

    function updateHeaderTools() {
        header.toolBarLayout = stackView.currentItem ? stackView.currentItem.headerTools : undefined
    }

    SequentialAnimation {
        id: changeToolsLayoutAnim
        NumberAnimation { id: fadeOut; target: header; property: "opacity"; to: 0;
            duration: 250; easing.type: Easing.OutQuad; loops: !toolBarLayout ? 0 : 1 }
        //headerTools may change now, so we have to close the drawer
        ScriptAction { script: closeDrawer() }
        ScriptAction { script: updateHeaderTools() }
        //tell the (maybe new) layout that we're its container
        ScriptAction { script: propagateHeaderReference() }
        NumberAnimation { id: fadeIn; target: header; property: "opacity"; to: 1;
            duration: 250; easing.type: Easing.OutQuad; loops: !toolBarLayout ? 0 : 1  }

    }

    NumberAnimation {
        id: slidingAnim
        target: header
        property: appWindow.isUiPortrait ? "y" : "x"
        from: appWindow.isUiPortrait ? header.y : header.x
        easing.type: Easing.OutExpo
    }

    function slideDrawerTo(coord) {
        slidingAnim.to = coord
        slidingAnim.start()
    }

    //THIS ITEM AND ITS CHILDREN ARE THE TOOLBAR (i.e. NOT what's inside the drawer!)
    //This item only resizes when UI rotates, while toolBarContainer is the one actually rotating
    Item {
        id: toolBarRect
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        //TODO: Check if changing this FilteringMouseArea->MouseArea has any side effects
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            property bool swiping: false
            property int swipeThreshold: 10
            property int gestureThreshold: drawer.width / 3 //this is only used in landscape
            //container coordinate (x OR y, depending on UI orientation) relative to the parent
            //of the header
            property int startCoord: 0
            //mouse coordinate (x OR y, depending on UI orientation) relative to the parent
            //of the header
            property int startMouseCoord: 0
            property int deltaCoord: 0

            //This is item which holds the toolbar and rotates with the UI
            Item {
                id: toolBarContainer
                //no anchors here, as we're using the rotation to change between portrait/landscape modes
                width: appWindow.isUiPortrait ? parent.width : parent.height
                height: appWindow.isUiPortrait ? parent.height : parent.width
                anchors.centerIn: parent
                data: toolBarLayout ? toolBarLayout : null
                rotation: appWindow.isUiPortrait ? 0 : -90
            }

            onPressed: {
                if (swiping) {
                    console.log("[HEADER] Swiping enabled in onPressed, report this.")
                    swiping = false
                }

                if (appWindow.isUiPortrait) {
                    startMouseCoord = (mouseY + header.y)
                    startCoord = header.y
                } else { //assuming that otherwise we're in landscape...is this safe?
                    startMouseCoord = (mouseX + header.x)
                    startCoord = header.x
                }
            }

            onPositionChanged: {
                if (appWindow.isUiPortrait) {
                    deltaCoord = (mouseY + header.y) - startMouseCoord
                    if (Math.abs(deltaCoord) > swipeThreshold && !swiping) { swiping = true; }

                    if (swiping) {
                        var swipingY = startCoord + deltaCoord
                        if ( swipingY > 0) {
                            header.y = Math.sqrt(swipingY)
                        } else {
                            if (swipingY < header.closedY) header.y = header.closedY
                            else header.y = swipingY
                        }
                    }
                } else {
                    deltaCoord = (mouseX + header.x) - startMouseCoord
                    if (Math.abs(deltaCoord) > swipeThreshold && !swiping) { swiping = true; }
                    if (swiping) {
                        //this is the coord that the drawer would be at if it were following our finger
                        var swipingX = startCoord + deltaCoord
                        //if the left/top side of the drawer is entering the screen, pull the breaks!
                        //quadratic slowdown effect
                        if ( swipingX > 0) {
                            header.x = Math.sqrt(swipingX)
                        } else {
                            //don't let the toolbar go out of screen
                            if (swipingX < header.closedX) header.x = header.closedX
                            else header.x = swipingX
                        }
                    }
                }
            }

            onReleased: {
                if (appWindow.isUiPortrait) {
                    if (!swiping) {
                        //Fully Close/Open the drawer
                        header.slideDrawerTo((header.y == header.closedY) ? 0 : header.closedY)
                    } else {
                        //this is the y at the top of the screen, relative to the header dock (header)
                        var topY = -header.y

                        //We cannot use QML's childAt because it requires both x and y
                        //and we don't have an x to provide (and it wouldn't make sense to have one,
                        //given the current specced behaviour of the header)
                        var item = drawer.getItemAt(topY)

                        //item is undefined when there's no item at the y of the top edge of the screen
                        //(this happens for example when you pull down the drawer so that its y is > 0)
                        if (item == undefined) {
                            //if the drawer is closed or half open, we open it totally.
                            //if it was opened already, we close it ("pull down to close" feature)
                            header.slideDrawerTo(startCoord == 0 ? header.closedY : 0)
                        } else {
                            header.slideDrawerTo(((topY - item.y) <= (speedBumpThreshold * item.height)) ? -item.y : -(item.y + item.height))
                        }
                    }
                } else {
                    if (!swiping) {
                        //Fully Close/Open the drawer
                        header.slideDrawerTo((header.x == header.closedX) ? 0 : header.closedX)
                    } else {
                        deltaCoord = (mouseX + header.x) - startMouseCoord
                        if (deltaCoord > gestureThreshold) {
                            header.slideDrawerTo(startCoord < 0 ? 0 : closedX)
                        } else if (deltaCoord < -gestureThreshold){
                            header.slideDrawerTo(closedX)
                        } else { //i.e (-gestureThreshold <= deltaCoord <= gestureThreshold)
                            header.slideDrawerTo((startCoord === header.closedX) ? header.closedX : 0)
                        }
                    }

                }
                swiping = false
            }
        }

        HeaderToolsIndicator{
            id: toolsIndicator
            width: parent.width
            height: Theme.itemHeightExtraSmall/8
            anchors.top: parent.top
            visible: drawerContainer.height > 0 && -header.y == drawerContainer.height
        }
    }

    Item {
        id: drawerContainer

        Binding on width {
            restoreMode: Binding.RestoreBinding
            value: drawer.width
            when: !appWindow.isUiPortrait
        }
        Binding on height {
            restoreMode: Binding.RestoreBinding
            value: drawer.height
            when: appWindow.isUiPortrait
        }

        Column {
            id: drawer

            //NOTE: if you set the spacing to something != 0 then you have to rewrite the logic which handles drawer speedbumps,
            //which currently relies on "spacing" being 0
            spacing: 0

            function getItemAt(y) {
                //skip the first child, which is the toolbar
                for (var i=0; i < children.length; i++) {
                    if (y >=children[i].y && y <= (children[i].y + children[i].height))
                        return children[i]
                }
            }

            Component.onCompleted: {
                if (toolBarLayout && toolBarLayout.drawerLevels) {
                    drawerContainer.children = toolBarLayout.drawerLevels
                }
            }
        }
    }
}
