package com.crisismap.app.data.model

import kotlinx.serialization.json.Json
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

class ContractsTest {
    private val json = Json {
        ignoreUnknownKeys = true
        explicitNulls = false
    }

    @Test
    fun decodesThinkTankArticleWithIosDefaults() {
        val article = json.decodeFromString<ThinkTankArticle>(
            """
            {
              "id": "a1",
              "think_tank": "RAND",
              "title": "Report",
              "url": "https://example.com",
              "date": "2026-04-01"
            }
            """.trimIndent()
        )

        assertEquals("RAND", article.thinkTank)
        assertEquals("", article.summary)
        assertEquals("general", article.category)
        assertEquals("unknown", article.status)
        assertEquals(emptyList<String>(), article.topics)
    }

    @Test
    fun decodesHyphenatedRegionRawValues() {
        assertEquals(Region.MiddleEast, json.decodeFromString<Region>("\"middle-east\""))
        assertEquals(Region.EastAsia, json.decodeFromString<Region>("\"east-asia\""))
    }

    @Test
    fun decodesCrisisEventNullableFields() {
        val event = json.decodeFromString<CrisisEvent>(
            """
            {
              "id": "e1",
              "title": "Title",
              "summary": "Summary",
              "category": "conflict",
              "level": "high",
              "location": null,
              "timestamp": "2026-04-01T00:00:00Z",
              "source": "Reuters",
              "sourceTier": "public"
            }
            """.trimIndent()
        )

        assertNull(event.location)
        assertNull(event.url)
        assertNull(event.actor)
        assertNull(event.entities)
        assertNull(event.newsSource)
    }
}
