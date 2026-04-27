package com.crisismap.app.ui.map

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class MapLibreMapConfigTest {
    @Test
    fun usesFreeCartoDarkMatterStyle() {
        assertEquals(
            "https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json",
            MapLibreMapConfig.styleUri
        )
        assertTrue(MapLibreMapConfig.styleUri.startsWith("https://"))
    }
}
