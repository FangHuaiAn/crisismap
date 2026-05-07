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
        return (listOf(feed.url) + feed.fallbackUrls)
            .firstNotNullOfOrNull { url ->
                fetchFeedUrl(feed = feed, url = url).takeIf { it.isNotEmpty() }
            }
            .orEmpty()
    }

    private fun fetchFeedUrl(feed: RssFeed, url: String): List<CrisisEvent> {
        val request = Request.Builder().url(url).build()
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
                        kind = feed.kind,
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
            RssFeed(
                id = "reuters",
                name = "Reuters",
                domain = "reuters.com",
                url = "https://feeds.reuters.com/Reuters/worldNews",
                kind = NewsSourceKind.Wire
            ),
            RssFeed(
                id = "ap",
                name = "AP News",
                domain = "apnews.com",
                url = "https://rsshub.app/apnews/topics/world-news",
                fallbackUrls = listOf("https://news.google.com/rss/search?q=site:apnews.com%20world&hl=en-US&gl=US&ceid=US:en"),
                kind = NewsSourceKind.Wire
            ),
            RssFeed(id = "bbc", name = "BBC News", domain = "bbc.com", url = "https://feeds.bbci.co.uk/news/world/rss.xml"),
            RssFeed(id = "nhk", name = "NHK World", domain = "nhk.or.jp", url = "https://www3.nhk.or.jp/rss/news/cat6.xml"),
            RssFeed(id = "aljazeera", name = "Al Jazeera", domain = "aljazeera.com", url = "https://www.aljazeera.com/xml/rss/all.xml"),
            RssFeed(id = "dw", name = "DW", domain = "dw.com", url = "https://rss.dw.com/rdf/rss-en-top"),
            RssFeed(id = "guardian-world", name = "The Guardian", domain = "theguardian.com", url = "https://www.theguardian.com/world/rss"),
            RssFeed(id = "npr-world", name = "NPR World", domain = "npr.org", url = "https://feeds.npr.org/1004/rss.xml"),
            RssFeed(id = "france24", name = "France 24", domain = "france24.com", url = "https://www.france24.com/en/rss"),
            RssFeed(id = "un-news", name = "UN News", domain = "news.un.org", url = "https://news.un.org/feed/subscribe/en/news/all/rss.xml")
        )
    }
}

data class RssFeed(
    val id: String,
    val name: String,
    val domain: String,
    val url: String,
    val fallbackUrls: List<String> = emptyList(),
    val kind: NewsSourceKind = NewsSourceKind.Publisher
)
