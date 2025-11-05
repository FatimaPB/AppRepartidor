import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'main_navigation.dart';

class Confirm_screen extends StatefulWidget {
  final String total;
  final bool paymentPending;

  const Confirm_screen({
    Key? key,
    this.total = '\$95,00',
    this.paymentPending = true,
  }) : super(key: key);

  @override
  State<Confirm_screen> createState() => _Confirm_screenState();
}

class _Confirm_screenState extends State<Confirm_screen> {
  File? _capturedImage;
  bool _paymentReceived = false;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Confirmar Entrega',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Sección de foto de entrega
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 20,
                                  color: Color(0xFFA38350),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Foto de Entrega',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 240,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: _capturedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.file(
                                          _capturedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.6,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          size: 48,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Tomar foto del producto entregado',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        height: 44,
                                        child: ElevatedButton.icon(
                                          onPressed: _openCamera,
                                          icon: const Icon(
                                            Icons.camera_alt,
                                            size: 18,
                                          ),
                                          label: const Text(
                                            'Abrir Cámara',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFA38350,
                                            ),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Confirmación de pago (solo si pendiente)
                    if (widget.paymentPending)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.attach_money,
                                    size: 20,
                                    color: Color(0xFFA38350),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Confirmación de Pago',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Pago en efectivo',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Recibido',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _paymentReceived =
                                                    !_paymentReceived;
                                              });
                                            },
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: _paymentReceived
                                                    ? const Color(0xFFA38350)
                                                    : Colors.white,
                                                border: Border.all(
                                                  color: _paymentReceived
                                                      ? const Color(0xFFA38350)
                                                      : Colors.grey.shade400,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: _paymentReceived
                                                  ? const Icon(
                                                      Icons.check,
                                                      size: 16,
                                                      color: Colors.white,
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFA38350,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Monto Total',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          widget.total,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFA38350),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Botón Completar Entrega fijo
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _canCompleteDelivery()
                      ? () => _completeDelivery(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA38350),
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: _canCompleteDelivery()
                            ? Colors.white
                            : Colors.grey.shade500,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Completar Entrega',
                        style: TextStyle(
                          color: _canCompleteDelivery()
                              ? Colors.white
                              : Colors.grey.shade500,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canCompleteDelivery() {
    return _capturedImage != null &&
        (widget.paymentPending ? _paymentReceived : true);
  }

  Future<void> _openCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (photo != null) {
        setState(() {
          _capturedImage = File(photo.path);
        });
      }
    } catch (e) {
      debugPrint("Error al abrir cámara: $e");
    }
  }

  void _completeDelivery(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 64,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Entrega Completada!',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'La entrega se ha registrado exitosamente con foto y confirmación de pago',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const MainNavigation()),
                    (route) => false, // elimina todo el stack anterior
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA38350),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Volver al Inicio',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
    },
);
}
}
