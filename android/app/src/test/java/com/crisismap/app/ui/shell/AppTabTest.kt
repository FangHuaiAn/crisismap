package com.crisismap.app.ui.shell

import org.junit.Assert.assertEquals
import org.junit.Test

class AppTabTest {
    @Test
    fun mvpVisibleTabsHideDeferredFeatures() {
        assertEquals(
            listOf(AppTab.Map, AppTab.News, AppTab.Research),
            AppTab.mvpVisible
        )
    }
}
