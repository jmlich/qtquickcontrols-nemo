/*
 * Copyright (C) 2017 Eetu Kahelin
 * Copyright (C) 2023-2025 Chupligin Sergey <neochapay@gmail.com>
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

#include "editfilter.h"
#include "nemofocussingleton.h"
#include <QKeyEvent>
#include <QVariant>

EditFilter::EditFilter(QObject* parent)
    : QObject(parent)
{
}

bool EditFilter::eventFilter(QObject* obj, QEvent* event)
{
    if (event->type() == QEvent::KeyPress) {
        QKeyEvent* keyEvent = static_cast<QKeyEvent*>(event);
        int key = keyEvent->key();
        if (key == Qt::Key_Backspace
            || key == Qt::Key_Return
            || key == Qt::Key_Escape) {
            emit backEvent();
        }
    }

    if (event->type() == QEvent::TouchBegin || event->type() == QEvent::TouchEnd) {
        emit touchEvent(event);
    }

    if (event->type() == QEvent::MouseButtonPress || event->type() == QEvent::TouchBegin) {
        NemoFocusSingleton* nemoFocus = NemoFocusSingleton::instance();
        if (nemoFocus->edit() != NULL) {
            nemoFocus->edit()->setProperty("focus", QVariant(false));
            return false;
        }
    }
    return QObject::eventFilter(obj, event);
}
