package com.example.minds_mobile_sdk_flutter_demo
import digital.minds.clients.sdk.kotlin.domain.helpers.Environment
import digital.minds.clients.sdk.kotlin.domain.helpers.ProcessType
import digital.minds.clients.sdk.kotlin.main.MindsSDK


class MindsConfig {
    companion object {
        fun enrollment(cpf: String, token: String, telephone: String): MindsSDK {
            return MindsSDK
                .Builder()
                .setToken(token)
                .setCPF(cpf)
                .setEnvironment(Environment.SANDBOX)
                .setExternalID(null)
                .setPhoneNumber(telephone)
                .setProcessType(ProcessType.ENROLLMENT)
                .setExternalCustomerId(null)
                .setShowDetails(true)
                .build()
        }

        fun authentication(cpf: String, token: String, telephone: String): MindsSDK {
            return MindsSDK
                .Builder()
                .setToken(token)
                .setCPF(cpf)
                .setEnvironment(Environment.SANDBOX)
                .setExternalID(null)
                .setPhoneNumber(telephone)
                .setProcessType(ProcessType.AUTHENTICATION)
                .setExternalCustomerId(null)
                .setShowDetails(true)
                .build()
        }
    }
}