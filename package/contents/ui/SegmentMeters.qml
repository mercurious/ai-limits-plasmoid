// SPDX-FileCopyrightText: 2026 SLASHLogin
// SPDX-License-Identifier: GPL-3.0-or-later

pragma ComponentBehavior: Bound

import QtQuick

import org.kde.kirigami as Kirigami

// The panel's segment meters for one provider: a column for each percentage
// the text value shows. Every column is a stack of LCD-style segments filled
// from the bottom. Lit segments are solid and the rest are ghosted, the way an
// LCD shows the segments it is not driving. Monochrome, like the rest of the
// panel.
Row {
    id: meters

    // Allowance left for each column, 0 to 100.
    required property var percents
    required property int segments
    required property int segmentHeight
    required property int columnWidth
    required property int columnGap

    spacing: meters.columnGap

    // Alpha lives in the colour, not in opacity, as in ProviderRow's gauges.
    readonly property color ghost: Qt.rgba(Kirigami.Theme.textColor.r,
                                           Kirigami.Theme.textColor.g,
                                           Kirigami.Theme.textColor.b,
                                           0.2)

    Repeater {
        model: meters.percents

        delegate: Column {
            id: column
            required property real modelData

            // Zero lights nothing. Anything above zero lights at least one
            // segment, so a nearly spent allowance does not read as exhausted.
            readonly property int lit: column.modelData <= 0
                ? 0
                : Math.max(1, Math.round(column.modelData * meters.segments / 100))

            width: meters.columnWidth
            spacing: 1

            Repeater {
                model: meters.segments

                delegate: Rectangle {
                    id: segment
                    required property int index

                    width: column.width
                    height: meters.segmentHeight
                    // The top segment is index 0, so the column fills upwards.
                    color: meters.segments - 1 - segment.index < column.lit
                        ? Kirigami.Theme.textColor
                        : meters.ghost
                }
            }
        }
    }
}
