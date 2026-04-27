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
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import okhttp3.OkHttpClient
import okhttp3.Request
import java.net.URLEncoder

class GdeltNewsSource(
    private val client: OkHttpClient = OkHttpClient(),
    private val json: Json = Json { ignoreUnknownKeys = true }
) : NewsDataSource {
    override val id = "gdelt"
    override val name = "GDELT"

    override suspend fun fetch(): List<CrisisEvent> = withContext(Dispatchers.IO) {
        val query = URLEncoder.encode(
            "(Taiwan OR China OR Ukraine OR Russia OR NATO OR Gaza OR Israel OR Iran OR \"Middle East\")",
            Charsets.UTF_8.name()
        )
        val url = "https://api.gdeltproject.org/api/v2/doc/doc?query=$query&mode=ArtList&format=json&maxrecords=20&sort=HybridRel"
        val request = Request.Builder().url(url).build()

        client.newCall(request).execute().use { response ->
            if (!response.isSuccessful) return@withContext emptyList()

            val body = response.body?.string().orEmpty()
            val root = runCatching { json.parseToJsonElement(body).jsonObject }.getOrNull()
                ?: return@withContext emptyList()
            val articles = root["articles"]?.jsonArray ?: return@withContext emptyList()

            articles.mapIndexedNotNull { index, item ->
                val obj = item.jsonObject
                val title = obj.string("title") ?: return@mapIndexedNotNull null
                val urlValue = obj.string("url")
                val domain = obj.string("domain")

                CrisisEvent(
                    id = "gdelt-${urlValue ?: index.toString()}",
                    title = title,
                    summary = title,
                    category = EventCategory.Statement,
                    level = ThreatLevel.Info,
                    timestamp = obj.string("seendate") ?: "2026-04-26T00:00:00Z",
                    source = name,
                    sourceTier = SourceTier.Public,
                    url = urlValue,
                    newsSource = NewsSourceDescriptor(
                        displayName = domain ?: name,
                        kind = NewsSourceKind.Aggregator,
                        identity = domain ?: id,
                        group = id,
                        attribution = NewsSourceAttribution.Derived,
                        domain = domain
                    )
                )
            }
        }
    }

    private fun JsonObject.string(key: String): String? =
        this[key]?.jsonPrimitive?.content?.takeIf { it.isNotBlank() }
}
