package com.crisismap.app.data.sources

import com.crisismap.app.data.model.NewsSourceKind
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class RssNewsSourceTest {
    @Test
    fun defaultFeedsMatchIosPublicCoverage() {
        val names = RssNewsSource.defaultFeeds.map { it.name }

        assertEquals(
            listOf(
                "Reuters",
                "AP News",
                "BBC News",
                "NHK World",
                "Al Jazeera",
                "DW",
                "The Guardian",
                "NPR World",
                "France 24",
                "UN News"
            ),
            names
        )
    }

    @Test
    fun wireFeedsExposeSourceKindAndFallbacks() {
        assertEquals(NewsSourceKind.Wire, feed("Reuters").kind)
        assertEquals(NewsSourceKind.Wire, feed("AP News").kind)
        assertTrue(feed("AP News").fallbackUrls.isNotEmpty())
    }

    private fun feed(name: String): RssFeed =
        RssNewsSource.defaultFeeds.first { it.name == name }
}
