/****************************************************************************************
**
** Copyright (C) 2021-2025 Chupligin Sergey <neochapay@gmail.com>
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

import QtQuick
import QtQuick.Controls

import org.nemomobile.statusnotifier 1.0

import Nemo.Controls

Page {
    id: root

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Status icon")
    }

    StatusNotifierItem {
        id: snItem
        status: StatusNotifierItem.PassiveStatus
        title: qsTr("Glacier UX")
        icon: "image://theme/terminal"
        overlayIcon: "image://theme/code"
        attentionIcon: "image://theme/window-close"


        onActivateRequested: {
            pageStack.pop();
        }

        onScrollRequested: {
            snItem.status = StatusNotifierItem.NeedsAttentionStatus
        }
    }

    Column {
        spacing: 40
        anchors.centerIn: parent
        Button {
            text: qsTr("Make icon active")
            onClicked:{
                snItem.status = StatusNotifierItem.ActiveStatus
            }
        }

        Button {
            text: qsTr("Make icon attention")
            onClicked:{
                snItem.status = StatusNotifierItem.NeedsAttentionStatus
            }
        }
    }
}
