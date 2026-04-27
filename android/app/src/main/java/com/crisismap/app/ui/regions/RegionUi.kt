package com.crisismap.app.ui.regions

import com.crisismap.app.data.model.Region

val Region.displayName: String
    get() = when (this) {
        Region.All -> "All"
        Region.MiddleEast -> "Middle East"
        Region.Europe -> "Europe"
        Region.EastAsia -> "East Asia"
        Region.Africa -> "Africa"
        Region.Americas -> "Americas"
    }
