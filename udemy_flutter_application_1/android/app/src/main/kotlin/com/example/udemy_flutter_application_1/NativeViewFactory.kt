package com.example.udemy_flutter_application_1

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory(private var getStateListHandler: GetStateListPlatformHandler) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val  creationParams = args as Map<String?, Any?>?
        return NativeView(context, viewId, creationParams, getStateListHandler)
    }
}
