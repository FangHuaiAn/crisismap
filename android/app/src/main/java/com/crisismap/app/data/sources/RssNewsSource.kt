package com.crisismap.app.data.sources

import com.crisismap.app.data.model.CrisisEvent
import com.crisismap.app.data.model.EventCategory
import com.crisismap.app.data.model.NewsSourceAttribution
import com.crisismap.app.data.model.NewsSourceDescriptor
import com.crisismap.app.data.model.NewsSourceKind
import com.crisismap.app.data.model.SourceTier
import com.crisismap.app.data.model.ThreatLevel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import org.w3c.dom.Element
import java.io.ByteArrayInputStream
import javax.xml.parsers.DocumentBuilderFactory

class RssNewsSource(
    private val client: OkHttpClient = OkHttpClient(),
    private val feeds: List<RssFeed> = defaultFeeds
) : NewsDataSource {
    override val id = "rss"
    override val name = "RSS"

    override suspend fun fetch(): List<CrisisEvent> = withContext(Dispatchers.IO) {
        feeds.flatMap { feed ->
            runCatching { fetchFeed(feed) }.getOrDefault(emptyList())
        }
    }

    private fun fetchFeed(feed: RssFeed): List<CrisisEvent> {
        val request = Request.Builder().url(feed.url).build()
        client.newCall(request).execute().use { response ->
            if (!response.isSuccessful) return emptyList()

            val bytes = response.body?.bytes() ?: return emptyList()
            val document = DocumentBuilderFactory.newInstance()
                .newDocumentBuilder()
                .parse(ByteArrayInputStream(bytes))
            val items = document.getElementsByTagName("item")

            return (0 until minOf(items.length, 12)).mapNotNull { index ->
                val item = items.item(index) as? Element ?: return@mapNotNull null
                val title = item.text("title") ?: return@mapNotNull null
                val link = item.text("link")

                CrisisEvent(
                    id = "rss-${feed.id}-$index-${link ?: title.hashCode()}",
                    title = title,
                    summary = item.text("description") ?: title,
                    category = EventCategory.Statement,
                    level = ThreatLevel.Info,
                    timestamp = item.text("pubDate") ?: "2026-04-26T00:00:00Z",
                    source = feed.name,
                    sourceTier = SourceTier.Public,
                    url = link,
                    newsSource = NewsSourceDescriptor(
                        displayName = feed.name,
                        kind = NewsSourceKind.Publisher,
                        identity = feed.id,
                        group = id,
                        attribution = NewsSourceAttribution.Direct,
                        domain = feed.domain
                    )
                )
            }
        }
    }

    private fun Element.text(name: String): String? {
        val nodes = getElementsByTagName(name)
        return if (nodes.length == 0) null else nodes.item(0).textContent?.trim()?.takeIf { it.isNotEmpty() }
    }

    companion object {
        val defaultFeeds = listOf(
            RssFeed(id = "bbc-world", name = "BBC", domain = "bbc.com", url = "https://feeds.bbci.co.uk/news/world/rss.xml"),
            RssFeed(id = "aljazeera", name = "Al Jazeera", domain = "aljazeera.com", url = "https://www.aljazeera.com/xml/rss/all.xml")
        )
    }
}

data class RssFeed(
    val id: String,
    val name: String,
    val domain: String,
    val url: String
)
