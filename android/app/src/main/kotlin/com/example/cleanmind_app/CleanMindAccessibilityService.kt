package com.example.cleanmind_app

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class CleanMindAccessibilityService :
    AccessibilityService() {

    private val blockedApps = setOf(
        "com.instagram.android",
        "com.google.android.youtube",
        "com.zhiliaoapp.musically",
        "com.twitter.android",
        "com.reddit.frontpage"
    )

    private var lastBlockedPackage: String? = null
    private var lastBlockTime: Long = 0

    override fun onServiceConnected() {

        super.onServiceConnected()

        val info = AccessibilityServiceInfo()

        info.eventTypes =
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or
            AccessibilityEvent.TYPE_WINDOWS_CHANGED

        info.feedbackType =
            AccessibilityServiceInfo.FEEDBACK_GENERIC

        info.flags =
            AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS or
            AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS

        info.notificationTimeout = 100

        serviceInfo = info

        Log.d(
            "CleanMind",
            "Accessibility Service conectado"
        )
    }

    override fun onAccessibilityEvent(
        event: AccessibilityEvent?
    ) {

        if (event == null) {
            return
        }

        val packageName =
            event.packageName?.toString()
                ?: return

        Log.d(
            "CleanMind",
            "TEST VERSION 999: $packageName"
        )

        if (!blockedApps.contains(packageName)) {
            return
        }

        val currentTime = System.currentTimeMillis()

        if (
            packageName == lastBlockedPackage &&
            currentTime - lastBlockTime < 2000
        ) {
            return
        }

        lastBlockedPackage = packageName
        lastBlockTime = currentTime

        Log.d(
            "CleanMind",
            "Blocked app detected: $packageName"
        )

        Handler(
            Looper.getMainLooper()
        ).postDelayed({

            performGlobalAction(
                GLOBAL_ACTION_HOME
            )

        }, 300)
    }

    override fun onInterrupt() {

        Log.d(
            "CleanMind",
            "Servicio interrumpido"
        )
    }
}