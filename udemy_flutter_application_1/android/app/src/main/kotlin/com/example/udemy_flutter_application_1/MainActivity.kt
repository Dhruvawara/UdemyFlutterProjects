package com.example.udemy_flutter_application_1

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.Configuration
import android.os.Handler
import android.os.Looper
import android.telephony.TelephonyManager
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.lang.reflect.Type
import java.text.SimpleDateFormat
import java.util.Date

class City(
    val id: String,
    val name: String,
    val state: String
)

class MainActivity : FlutterActivity() {
    // Parse the JSON string using Gson
    private val gson = Gson()
    private val jsonString = """[
  {
    "id": "1",
    "name": "Mumbai",
    "state": "Maharashtra"
  },
  {
    "id": "2",
    "name": "Delhi",
    "state": "Delhi"
  },
  {
    "id": "3",
    "name": "Bengaluru",
    "state": "Karnataka"
  },
  {
    "id": "4",
    "name": "Ahmedabad",
    "state": "Gujarat"
  },
  {
    "id": "5",
    "name": "Hyderabad",
    "state": "Telangana"
  },
  {
    "id": "6",
    "name": "Chennai",
    "state": "Tamil Nadu"
  },
  {
    "id": "7",
    "name": "Kolkata",
    "state": "West Bengal"
  },
  {
    "id": "8",
    "name": "Pune",
    "state": "Maharashtra"
  },
  {
    "id": "9",
    "name": "Jaipur",
    "state": "Rajasthan"
  },
  {
    "id": "10",
    "name": "Surat",
    "state": "Gujarat"
  },
  {
    "id": "11",
    "name": "Lucknow",
    "state": "Uttar Pradesh"
  },
  {
    "id": "12",
    "name": "Kanpur",
    "state": "Uttar Pradesh"
  },
  {
    "id": "13",
    "name": "Nagpur",
    "state": "Maharashtra"
  },
  {
    "id": "14",
    "name": "Patna",
    "state": "Bihar"
  },
  {
    "id": "15",
    "name": "Indore",
    "state": "Madhya Pradesh"
  },
  {
    "id": "16",
    "name": "Thane",
    "state": "Maharashtra"
  },
  {
    "id": "17",
    "name": "Bhopal",
    "state": "Madhya Pradesh"
  },
  {
    "id": "18",
    "name": "Visakhapatnam",
    "state": "Andhra Pradesh"
  }
]""".trimIndent()

    private val eventChannelTimer = "timeHandlerEvent"
    private val eventChannelGetCityData = "getCityDataHandlerEvent"
    private val eventChannelGetStateData = "getStateDataHandlerEvent"
    private val getStateDataHandlerPlatformEvent = "getStateDataHandlerPlatformEvent"
    private val channel = "com.example.platform_channel_in_flutter/Udemy Flutter Application 1"
    private val getStateListHandler = GetStateListPlatformHandler()
    private val nativeViewFactory: NativeViewFactory = NativeViewFactory(getStateListHandler)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Save the FlutterEngine to the cache with a unique ID
        FlutterEngineCache.getInstance().put("your_flutter_engine_id", flutterEngine)

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "HybridCompositionWidget",
                nativeViewFactory
            )

        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory(
                "VirtualDisplayWidget",
                nativeViewFactory
            )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                when (call.method) {
                    "getDeviceModel" -> {
                        val deviceModel = getDeviceType(context)
                        result.success(deviceModel)
                    }

                    "getCityData" -> {
                        val cityData = getCityData()
                        result.success(cityData)
                    }

                    "getStateFromCity" -> {
                        val stateName = getStateFromCity(call.arguments.toString())
                        result.success(stateName)
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            eventChannelTimer
        ).setStreamHandler(
            TimeHandler
        )

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            eventChannelGetCityData
        ).setStreamHandler(
            GetCityListHandler
        )

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            eventChannelGetStateData
        ).setStreamHandler(
            GetStateListHandler
        )

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            getStateDataHandlerPlatformEvent
        ).setStreamHandler(
            this.getStateListHandler
        )
    }

    private fun getDeviceType(context: Context): String {
        val telephonyManager = context.getSystemService(TELEPHONY_SERVICE) as TelephonyManager

        // Check if the device has telephony features
        val isPhone = telephonyManager.phoneType != TelephonyManager.PHONE_TYPE_NONE

        // Check the screen size to determine if it's a tablet
        val isTablet =
            context.resources.configuration.screenLayout and Configuration.SCREENLAYOUT_SIZE_MASK >= Configuration.SCREENLAYOUT_SIZE_LARGE

        return if (isTablet) {
            "Tablet"
        } else if (isPhone) {
            "Phone"
        } else {
            "Unknown"
        }
    }

    private fun getCityData(): List<String> {

        val listType: Type? = object : TypeToken<List<City?>?>() {}.type

        val cityList: List<City> = gson.fromJson(jsonString, listType)

        return cityList.map { city -> city.name }
    }

    private fun getStateFromCity(cityName: String): String {
        val listType: Type? = object : TypeToken<List<City?>?>() {}.type

        val cityList: List<City> = gson.fromJson(jsonString, listType)

        return cityList.first { city -> city.name == cityName }.state
    }

    object TimeHandler : EventChannel.StreamHandler {
        // Handle event in main thread.
        private var handler = Handler(Looper.getMainLooper())

        // Declare our eventSink later it will be initialized
        private var eventSink: EventChannel.EventSink? = null

        @SuppressLint("SimpleDateFormat")
        override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
            eventSink = sink
            // every second send the time
            val r: Runnable = object : Runnable {
                override fun run() {
                    handler.post {
                        val dateFormat = SimpleDateFormat("HH:mm:ss")
                        val time = dateFormat.format(Date())
                        eventSink?.success(time)
                    }
                    handler.postDelayed(this, 1000)
                }
            }
            handler.postDelayed(r, 1000)
        }

        override fun onCancel(p0: Any?) {
            eventSink = null
        }
    }

    object GetCityListHandler : EventChannel.StreamHandler {
        // Parse the JSON string using Gson
        val gson = Gson()
        val jsonString = """[
  {
    "id": "1",
    "name": "Mumbai",
    "state": "Maharashtra"
  },
  {
    "id": "2",
    "name": "Delhi",
    "state": "Delhi"
  },
  {
    "id": "3",
    "name": "Bengaluru",
    "state": "Karnataka"
  },
  {
    "id": "4",
    "name": "Ahmedabad",
    "state": "Gujarat"
  },
  {
    "id": "5",
    "name": "Hyderabad",
    "state": "Telangana"
  },
  {
    "id": "6",
    "name": "Chennai",
    "state": "Tamil Nadu"
  },
  {
    "id": "7",
    "name": "Kolkata",
    "state": "West Bengal"
  },
  {
    "id": "8",
    "name": "Pune",
    "state": "Maharashtra"
  },
  {
    "id": "9",
    "name": "Jaipur",
    "state": "Rajasthan"
  },
  {
    "id": "10",
    "name": "Surat",
    "state": "Gujarat"
  },
  {
    "id": "11",
    "name": "Lucknow",
    "state": "Uttar Pradesh"
  },
  {
    "id": "12",
    "name": "Kanpur",
    "state": "Uttar Pradesh"
  },
  {
    "id": "13",
    "name": "Nagpur",
    "state": "Maharashtra"
  },
  {
    "id": "14",
    "name": "Patna",
    "state": "Bihar"
  },
  {
    "id": "15",
    "name": "Indore",
    "state": "Madhya Pradesh"
  },
  {
    "id": "16",
    "name": "Thane",
    "state": "Maharashtra"
  },
  {
    "id": "17",
    "name": "Bhopal",
    "state": "Madhya Pradesh"
  },
  {
    "id": "18",
    "name": "Visakhapatnam",
    "state": "Andhra Pradesh"
  }
]""".trimIndent()

        // Handle event in main thread.
        private var handler = Handler(Looper.getMainLooper())

        // Declare our eventSink later it will be initialized
        private var eventSink: EventChannel.EventSink? = null

        override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
            eventSink = sink
            val listType: Type? = object : TypeToken<List<City?>?>() {}.type

            val cityList: List<City> = gson.fromJson(jsonString, listType)

            eventSink?.success(cityList.map { city -> city.name })
        }

        override fun onCancel(p0: Any?) {
            eventSink = null
        }
    }

    object GetStateListHandler : EventChannel.StreamHandler {
        // Parse the JSON string using Gson
        private val gson = Gson()
        private val jsonString = """[
  {
    "id": "1",
    "name": "Mumbai",
    "state": "Maharashtra"
  },
  {
    "id": "2",
    "name": "Delhi",
    "state": "Delhi"
  },
  {
    "id": "3",
    "name": "Bengaluru",
    "state": "Karnataka"
  },
  {
    "id": "4",
    "name": "Ahmedabad",
    "state": "Gujarat"
  },
  {
    "id": "5",
    "name": "Hyderabad",
    "state": "Telangana"
  },
  {
    "id": "6",
    "name": "Chennai",
    "state": "Tamil Nadu"
  },
  {
    "id": "7",
    "name": "Kolkata",
    "state": "West Bengal"
  },
  {
    "id": "8",
    "name": "Pune",
    "state": "Maharashtra"
  },
  {
    "id": "9",
    "name": "Jaipur",
    "state": "Rajasthan"
  },
  {
    "id": "10",
    "name": "Surat",
    "state": "Gujarat"
  },
  {
    "id": "11",
    "name": "Lucknow",
    "state": "Uttar Pradesh"
  },
  {
    "id": "12",
    "name": "Kanpur",
    "state": "Uttar Pradesh"
  },
  {
    "id": "13",
    "name": "Nagpur",
    "state": "Maharashtra"
  },
  {
    "id": "14",
    "name": "Patna",
    "state": "Bihar"
  },
  {
    "id": "15",
    "name": "Indore",
    "state": "Madhya Pradesh"
  },
  {
    "id": "16",
    "name": "Thane",
    "state": "Maharashtra"
  },
  {
    "id": "17",
    "name": "Bhopal",
    "state": "Madhya Pradesh"
  },
  {
    "id": "18",
    "name": "Visakhapatnam",
    "state": "Andhra Pradesh"
  }
]""".trimIndent()

        // Handle event in main thread.
        private var handler = Handler(Looper.getMainLooper())

        // Declare our eventSink later it will be initialized
        private var eventSink: EventChannel.EventSink? = null

        override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
            val cityName = p0.toString()
            eventSink = sink
            val listType: Type? = object : TypeToken<List<City?>?>() {}.type

            val cityList: List<City> = gson.fromJson(jsonString, listType)

            eventSink?.success(cityList.first { city -> city.name == cityName }.state)
        }

        override fun onCancel(p0: Any?) {
            eventSink = null
        }
    }
}

class GetStateListPlatformHandler : EventChannel.StreamHandler {

    // Declare our eventSink later it will be initialized
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
        eventSink = sink
    }

    override fun onCancel(p0: Any?) {
        eventSink = null
    }

    fun sendEvent(tempStateName: String) {
        eventSink?.success(tempStateName)
    }
}


