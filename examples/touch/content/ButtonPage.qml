/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
** Copyright (C) 2021-2025 Chupligin Sergey <neochapay@gmail.com>
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick
import QtQuick.Controls

import Nemo
import Nemo.Controls

Page {
    id: root

    headerTools: HeaderToolsLayout {
        showBackButton: false;
        title: qsTr("Buttons (portrait only, no back arrow)")
    }
    allowedOrientations: Qt.PortraitOrientation

    Column {
        spacing: 40
        anchors.centerIn: parent

        Button {
            property bool isGlacier: true
            anchors.margins: 20
            text: isGlacier ? "Set Ugly Theme" : "Set Nice Theme"
            onClicked: {
                if (isGlacier ) {
                    Theme.loadTheme("/usr/lib/qt/qml/QtQuick/Controls/Styles/Nemo/themes/glacier_orange.json")
                } else {
                    Theme.loadTheme("/usr/lib/qt/qml/QtQuick/Controls/Styles/Nemo/themes/glacier_black.json")
                }
                isGlacier = !isGlacier;
            }

        }

        Button {
            anchors.margins: 20
            enabled: false
            text: "Disabled"
        }

        Button {
            anchors.margins: 20
            primary: true
            text: "Go back"
            onClicked: if (stackView) stackView.pop()
        }
    }

}
