/****************************************************************************************
**
** Copyright (C) 2017 Eetu Kahelin
** All rights reserved.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the author nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

import QtQuick 2.6
import QtQuick.Controls

import Nemo
import Nemo.Controls

Button {
    id: control
    property color highlightColor: Theme.accentColor
//    property bool highlighted: pressed
    property bool _showPress: highlighted || pressTimer.running
    property string source

    property string highlightSource: {
        if (source != "") {
            var tmpSrc = source.toString()
            var i = tmpSrc.lastIndexOf("?")
            if (i !== -1) {
                tmpSrc = tmpSrc.substring(0, i)
            }
            return tmpSrc + "?" + highlightColor
        } else {
            return ""
        }
    }

    onPressedChanged: {
        if (pressed) {
            pressTimer.start()
        }
    }
    width: Theme.itemHeightLarge
    height: width

    Timer {
        id: pressTimer
        interval: 20
    }

    background: Image {
        fillMode: Image.PreserveAspectFit
        opacity: control.enabled ? 1.0 : 0.5
        source:control._showPress ? control.highlightSource : control.source
    }
}

