package com.crisismap.app.data.sources

import com.crisismap.app.data.model.ThinkTankWeekly
import com.crisismap.app.data.model.TopicsIndex
import com.crisismap.app.data.model.WeekIndex
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json
import okhttp3.OkHttpClient
import okhttp3.Request
import java.io.IOException

interface ThinkTankApi {
    suspend fun fetchWeekIndex(): WeekIndex
    suspend fun fetchTopicsIndex(): TopicsIndex
    suspend fun fetchWeekly(week: String): ThinkTankWeekly
}

class HttpThinkTankApi(
    private val client: OkHttpClient = OkHttpClient(),
    private val json: Json = Json {
        ignoreUnknownKeys = true
        explicitNulls = false
    },
    private val rootUrl: String = "https://thinktankbriefdata.strataperture.net",
    private val year: Int = 2026
) : ThinkTankApi {
    private val yearUrl = "$rootUrl/$year"

    override suspend fun fetchWeekIndex(): WeekIndex = fetchJson("$yearUrl/weeks.json")

    override suspend fun fetchTopicsIndex(): TopicsIndex = fetchJson("$rootUrl/topics.json")

    override suspend fun fetchWeekly(week: String): ThinkTankWeekly = fetchJson("$yearUrl/$week.json")

    private suspend inline fun <reified T> fetchJson(url: String): T = withContext(Dispatchers.IO) {
        val request = Request.Builder().url(url).build()
        client.newCall(request).execute().use { response ->
            if (!response.isSuccessful) {
                throw IOException("HTTP ${response.code} for $url")
            }

            val body = response.body?.string() ?: throw IOException("Empty body for $url")
            json.decodeFromString<T>(body)
        }
    }
}
