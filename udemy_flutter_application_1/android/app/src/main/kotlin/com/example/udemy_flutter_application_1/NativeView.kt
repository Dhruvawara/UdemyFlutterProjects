package com.example.udemy_flutter_application_1

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.LinearLayout
import android.widget.ListView
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import io.flutter.plugin.platform.PlatformView
import java.lang.reflect.Type

internal class NativeView(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?,
    getStateListHandler: GetStateListPlatformHandler
) :
    PlatformView {
    private val layout: LinearLayout
    private val listView: ListView
    private val recyclerView: RecyclerView
    private val adapter2: CityListAdapter

    override fun getView(): View {
        return layout
    }

    override fun dispose() {}

    init {
        layout = LinearLayout(context)
        layout.orientation = LinearLayout.VERTICAL

        listView = ListView(context)
        listView.setBackgroundColor(Color.rgb(0, 255, 255))

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

        val listType: Type? = object : TypeToken<List<City?>?>() {}.type

        val cityList: List<City> = gson.fromJson(
            jsonString,
            listType
        )

        // Example data for the ListView
        val data = cityList.map { city -> city.name }.toTypedArray()

        // Adapter for the ListView
        val adapter = ArrayAdapter(context, android.R.layout.simple_list_item_1, data)

        // Set the adapter to the ListView
        listView.adapter = adapter

        // Set an item click listener
        listView.setOnItemClickListener { _, _, position, _ ->
            val selectedItem = cityList[position].state

            // Display a Toast with the clicked item
            Toast.makeText(context, "Clicked: $selectedItem", Toast.LENGTH_SHORT).show()

            getStateListHandler.sendEvent(selectedItem)
        }

        recyclerView = RecyclerView(context)
        recyclerView.layoutManager = LinearLayoutManager(context)
        recyclerView.setBackgroundColor(Color.rgb(0, 255, 255))

        // Parse the JSON string using Gson
        val listTypeR: Type? = object : TypeToken<List<City?>?>() {}.type

        val cityListR: List<City> = gson.fromJson(
            jsonString,
            listTypeR
        )

        adapter2 = CityListAdapter(context, cityListR, getStateListHandler)

        recyclerView.adapter = adapter2

        if (creationParams.isNullOrEmpty()) {
            // Add the ListView to the layout
            layout.addView(listView)
        } else {
            // Add the RecyclerView to the layout when there is a
            // argument passed to native from flutter
            layout.addView(recyclerView)
        }
    }
}


// Import statements

class CityListAdapter(
    private val context: Context,
    private val cityList: List<City>,
    private val getStateListHandler: GetStateListPlatformHandler
) : RecyclerView.Adapter<CityListAdapter.ViewHolder>() {

    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val itemNameTextView: TextView = itemView.findViewById(R.id.itemNameTextView)
        val itemStateTextView: TextView = itemView.findViewById(R.id.itemStateTextView)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.list_item_layout, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val city = cityList[position]

        holder.itemNameTextView.text = city.name
        holder.itemStateTextView.text = city.state

        holder.itemView.setOnClickListener {
            // Handle item click
            val selectedItem = city.state
            Toast.makeText(context, "Clicked: $selectedItem", Toast.LENGTH_SHORT).show()
            getStateListHandler.sendEvent(selectedItem)
        }
    }

    override fun getItemCount(): Int {
        return cityList.size
    }
}
