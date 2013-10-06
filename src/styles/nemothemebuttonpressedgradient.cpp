/*
 * Copyright (C) 2013 Lucien Xu <sfietkonstantin@free.fr>
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

// This class is autogenerated using themehelper.py
// Any modification done in this file will be overridden

#include "nemothemebuttonpressedgradient.h"

NemoThemeButtonPressedGradient::NemoThemeButtonPressedGradient(QObject *parent)
    : QObject(parent)
    , m_width(240)
    , m_height(240)
    , m_center(0.29)
    , m_edge(0.5)
{
}

QColor NemoThemeButtonPressedGradient::centerColor() const
{
    return m_centerColor;
}

void NemoThemeButtonPressedGradient::setCenterColor(QColor centerColor)
{
    if (m_centerColor != centerColor) {
        m_centerColor = centerColor;
        emit centerColorChanged();
    }
}

QColor NemoThemeButtonPressedGradient::edgeColor() const
{
    return m_edgeColor;
}

void NemoThemeButtonPressedGradient::setEdgeColor(QColor edgeColor)
{
    if (m_edgeColor != edgeColor) {
        m_edgeColor = edgeColor;
        emit edgeColorChanged();
    }
}

int NemoThemeButtonPressedGradient::width() const
{
    return m_width;
}

void NemoThemeButtonPressedGradient::setWidth(const int &width)
{
    if (m_width != width) {
        m_width = width;
        emit widthChanged();
    }
}

int NemoThemeButtonPressedGradient::height() const
{
    return m_height;
}

void NemoThemeButtonPressedGradient::setHeight(const int &height)
{
    if (m_height != height) {
        m_height = height;
        emit heightChanged();
    }
}

double NemoThemeButtonPressedGradient::center() const
{
    return m_center;
}

void NemoThemeButtonPressedGradient::setCenter(const double &center)
{
    if (m_center != center) {
        m_center = center;
        emit centerChanged();
    }
}

double NemoThemeButtonPressedGradient::edge() const
{
    return m_edge;
}

void NemoThemeButtonPressedGradient::setEdge(const double &edge)
{
    if (m_edge != edge) {
        m_edge = edge;
        emit edgeChanged();
    }
}
