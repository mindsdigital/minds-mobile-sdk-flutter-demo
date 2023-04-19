package com.example.minds_mobile_sdk_flutter_demo
import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import digital.minds.clients.sdk.android.MindsDigital
import digital.minds.clients.sdk.kotlin.data.model.VoiceMatchResponse
import digital.minds.clients.sdk.kotlin.domain.constants.VOICE_MATCH_RESPONSE
import digital.minds.clients.sdk.kotlin.domain.exceptions.*
import digital.minds.clients.sdk.kotlin.main.MindsSDK
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : FlutterActivity() {
    private val channel = "digital.minds"
    private lateinit var enrollmentMindsSDK: MindsSDK
    private lateinit var authenticationMindsSDK: MindsSDK
    private lateinit var _result: MethodChannel.Result

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                val cpf: String? = call.argument("cpf")
                val token: String? = call.argument("token")
                val telephone: String? = call.argument("telephone")
                _result = result

                try {
                    when (call.method) {
                        "authentication" -> {
                            authenticationMindsSDK =
                                MindsConfig.authentication(cpf!!, token!!, telephone!!)
                            CoroutineScope(Dispatchers.Main).launch {
                                try {
                                    val intent =
                                        MindsDigital.getIntent(context, authenticationMindsSDK)
                                    startActivityForResult(intent, 0)
                                } catch (e: InvalidCPF) {
                                    result.error("invalid_cpf", e.message, null)
                                } catch (e: InvalidPhoneNumber) {
                                    result.error("invalid_phone_number", e.message, null)
                                } catch (e: CustomerNotFoundToPerformVerification) {
                                    result.error("customer_not_found", e.message, null)
                                } catch (e: CustomerNotEnrolled) {
                                    result.error("customer_not_enrolled", e.message, null)
                                } catch (e: CustomerNotCertified) {
                                    result.error("customer_not_certified", e.message, null)
                                } catch (e: InvalidToken) {
                                    result.error("invalid_token", e.message, null)
                                } catch (e: InternalServerException) {
                                    result.error("internal_server_error", e.message, null)
                                } catch (e: Exception) {
                                    result.error("MINDS_SDK_INIT_ERROR", e.message, null)
                                }
                            }
                        }

                        "enrollment" -> {
                            enrollmentMindsSDK = MindsConfig.enrollment(cpf!!, token!!, telephone!!)
                            CoroutineScope(Dispatchers.Main).launch {
                                try {
                                    val intent = MindsDigital.getIntent(context, enrollmentMindsSDK)
                                    startActivityForResult(intent, 0)
                                } catch (e: InvalidCPF) {
                                    result.error("invalid_cpf", e.message, null)
                                } catch (e: InvalidPhoneNumber) {
                                    result.error("invalid_phone_number", e.message, null)
                                } catch (e: CustomerNotFoundToPerformVerification) {
                                    result.error("customer_not_found", e.message, null)
                                } catch (e: CustomerNotEnrolled) {
                                    result.error("customer_not_enrolled", e.message, null)
                                } catch (e: CustomerNotCertified) {
                                    result.error("customer_not_certified", e.message, null)
                                } catch (e: InvalidToken) {
                                    result.error("invalid_token", e.message, null)
                                } catch (e: InternalServerException) {
                                    result.error("internal_server_error", e.message, null)
                                } catch (e: Exception) {
                                    result.error("MINDS_SDK_INIT_ERROR", e.message, null)
                                }
                            }
                        }

                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("MINDS_SDK_INIT_ERROR", e.message, null)
                }
            }
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode != Activity.RESULT_OK || data == null) return
        val mindsSDKResponse = data.extras?.get(VOICE_MATCH_RESPONSE) as? VoiceMatchResponse
        val jsonObject = JSONObject().apply {
            put("success", mindsSDKResponse?.success)
            put("error", JSONObject().apply {
                put("code", mindsSDKResponse?.error?.code)
                put("description", mindsSDKResponse?.error?.description)
            })
            put("id", mindsSDKResponse?.id)
            put("cpf", mindsSDKResponse?.cpf)
            put("external_id", mindsSDKResponse?.external_id)
            put("created_at", mindsSDKResponse?.created_at)
            put("result", JSONObject().apply {
                put("recommended_action", mindsSDKResponse?.result?.recommended_action)
                put("reasons", JSONArray(mindsSDKResponse?.result?.reasons))
            })
            put("details", JSONObject().apply {
                put("flag", JSONObject().apply {
                    put("id", mindsSDKResponse?.details?.flag?.id)
                    put("type", mindsSDKResponse?.details?.flag?.type)
                    put("description", mindsSDKResponse?.details?.flag?.description)
                    put("status", mindsSDKResponse?.details?.flag?.status)
                })
                put("voice_match", JSONObject().apply {
                    put("result", mindsSDKResponse?.details?.voice_match?.result)
                    put("confidence", mindsSDKResponse?.details?.voice_match?.confidence)
                    put("status", mindsSDKResponse?.details?.voice_match?.status)
                })
                put("antispoofing", JSONObject().apply {
                    put("result", mindsSDKResponse?.details?.antispoofing?.result)
                    put("status", mindsSDKResponse?.details?.antispoofing?.status)
                })
            })
        }
        val jsonString = jsonObject.toString()
        _result.success(jsonString)
    }
}
