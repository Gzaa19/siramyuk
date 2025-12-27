import 'package:flutter/material.dart';
import 'package:siramyuk/models/plant.dart';
import 'package:siramyuk/services/plant_service.dart';

class AddPlantScreen extends StatefulWidget {
  final Plant? plant; // If provided, we're editing

  const AddPlantScreen({super.key, this.plant});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final PlantService _plantService = PlantService();

  late TextEditingController _nameController;
  late TextEditingController _nicknameController;
  late TextEditingController _locationController;
  late TextEditingController _imageController;
  late TextEditingController _wateringIntervalController;
  late TextEditingController _ageController;

  String _selectedStatus = 'healthy';
  String _selectedLight = 'Indirect';
  String _selectedHumidity = 'Medium';

  static const Color primaryColor = Color(0xFF0DF20D);
  static const Color backgroundLight = Color(0xFFF5F8F5);
  static const Color backgroundDark = Color(0xFF102210);

  final List<String> _statusOptions = ['healthy', 'needs_water', 'attention'];
  final List<String> _lightOptions = [
    'Full Sun',
    'Bright indirect',
    'Indirect',
    'Low light',
  ];
  final List<String> _humidityOptions = ['Low', 'Medium', 'High'];

  final List<String> _sampleImages = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCPfN1_xmnJljjJHdyBNb9ODNZD8912TbfAyl7QTlz6qOp4xe8pVKrdllhGB_DvJxL6VIgz28tXxzOwrSZS34nJ-OFgkT1M9ha1uOAlZqRQUd1DjJc5tn7C_E4qljScv7i-0sH-hGMzRzo9rDst69pVKRyeoA7q6EmW4tvjXdiiMTc2TyGWYBbeYVCIFoiS9TIV7n3farAN1Z2DxjmcXD4RD45uNJIhBwyI45I25aMnNcIw70OcvBY5OLU8zOHw5o7YjYxb7NHQyVfP',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCwKL6fwRAcWNt0fQbw7VaskLffkBDfYB1X7iXKI9X_bwSHtJaqHfLQoa5cpJiftp9RgysiPqBKHFI3ADxNDuOztNwkLKUDhjPcFhvE_6Pwue9SwMNx_BHExzz0daknnZ8O_l22yb8GtRNFXnX0PBOwmRAIuY0OZml-d4vahtPAT6MXkmPm80ZJPR3olTpe3SoF3-ydVoQtJP61J-sr2zZTdYutEV3Y5XJX4wG0qrMVKzKC8fCcBwaDTLIzCEzYT0zy3iCVNJlRtVce',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBxD8aVznJkmNs-9jJSda_oFVjbLTRPRtMmYBdKwuLpjebXEfH09Ozq0wXjWUn-tkcWvuIRpN5iySCYyXy4vIVLSh_zqVPUOcWI4V8vuF4GrDxnAkq8JtPX_YFz5SdSTs2_sWrSRzThUUrqVBnWZ3bwMMcL1Z4-mAWtgDvK-_vdr3ifYXXMqKx1x6_OEP2XxH9pPGTOYnqO1iSxVX-vfQ-5UoMvfor8jnFzKvMHIP5bN7vBgN5WtmUvg42Z08hUwsTAHoM3rZ-ZdyWU',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuA0VomZYpodjpgaaKxTgxQsLPu9o5xn7-13ag8biTG8biPJN1vYtv6AKn_XKDvJ9m06lfKLv-thQbk9Q3wEYKYkgc29SaZnXM0bhhrVOwdoTNzyrflLwMmfh1aix1Mqi3VykxJMzrWVEVESHMwQrYNI4tkLgFhaW2CNo1JnXlWjJO92l7pfIMt1erpzIh4mqsMpxlV3Z-gnQlZkr1R9xRCSwdJVpf-ChLqbSc0c39IMWG8jS52v_z9OCiZ8y3Ca21GBo-cioOVV-zZ_',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant?.name ?? '');
    _nicknameController = TextEditingController(
      text: widget.plant?.nickname ?? '',
    );
    _locationController = TextEditingController(
      text: widget.plant?.location ?? '',
    );
    _imageController = TextEditingController(
      text: widget.plant?.image ?? _sampleImages[0],
    );
    _wateringIntervalController = TextEditingController(
      text: widget.plant?.wateringIntervalDays?.toString() ?? '7',
    );
    _ageController = TextEditingController(
      text: widget.plant?.ageMonths?.toString() ?? '1',
    );

    if (widget.plant != null) {
      _selectedStatus = widget.plant!.status;
      _selectedLight = widget.plant!.light ?? 'Indirect';
      _selectedHumidity = widget.plant!.humidity ?? 'Medium';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _locationController.dispose();
    _imageController.dispose();
    _wateringIntervalController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _savePlant() {
    if (_formKey.currentState!.validate()) {
      final plant = Plant(
        id:
            widget.plant?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        nickname: _nicknameController.text.trim().isNotEmpty
            ? _nicknameController.text.trim()
            : null,
        location: _locationController.text.trim(),
        image: _imageController.text.trim(),
        status: _selectedStatus,
        isFavorite: widget.plant?.isFavorite ?? false,
        lastWatered: widget.plant?.lastWatered ?? DateTime.now(),
        wateringIntervalDays:
            int.tryParse(_wateringIntervalController.text) ?? 7,
        light: _selectedLight,
        temperature: '18-24°C',
        humidity: _selectedHumidity,
        ageMonths: int.tryParse(_ageController.text) ?? 1,
      );

      if (widget.plant != null) {
        _plantService.updatePlant(plant);
      } else {
        _plantService.addPlant(plant);
      }

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.plant != null
                ? 'Tanaman berhasil diperbarui'
                : 'Tanaman berhasil ditambahkan',
          ),
          backgroundColor: primaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? backgroundDark : backgroundLight;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDarkMode
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final inputBgColor = isDarkMode
        ? Colors.white.withOpacity(0.05)
        : Colors.white;
    final borderColor = isDarkMode
        ? Colors.white.withOpacity(0.1)
        : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.plant != null ? 'Edit Tanaman' : 'Tambah Tanaman',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _savePlant,
            child: const Text(
              'Simpan',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Preview
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                    image: DecorationImage(
                      image: NetworkImage(_imageController.text),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                  child: _imageController.text.isEmpty
                      ? Icon(Icons.local_florist, size: 60, color: subTextColor)
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Image Selection
              Text(
                'Pilih Gambar',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _sampleImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected =
                        _imageController.text == _sampleImages[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _imageController.text = _sampleImages[index];
                        });
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? primaryColor : borderColor,
                            width: isSelected ? 2 : 1,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(_sampleImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: isSelected
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: primaryColor.withOpacity(0.3),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Name Field
              _buildTextField(
                controller: _nameController,
                label: 'Nama Tanaman *',
                hint: 'Contoh: Monstera Deliciosa',
                textColor: textColor,
                inputBgColor: inputBgColor,
                borderColor: borderColor,
                isDarkMode: isDarkMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tanaman harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nickname Field
              _buildTextField(
                controller: _nicknameController,
                label: 'Nama Panggilan',
                hint: 'Contoh: Monty',
                textColor: textColor,
                inputBgColor: inputBgColor,
                borderColor: borderColor,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 16),

              // Location Field
              _buildTextField(
                controller: _locationController,
                label: 'Lokasi *',
                hint: 'Contoh: Ruang Tamu',
                textColor: textColor,
                inputBgColor: inputBgColor,
                borderColor: borderColor,
                isDarkMode: isDarkMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              _buildDropdown(
                label: 'Status',
                value: _selectedStatus,
                items: _statusOptions,
                displayText: (status) {
                  switch (status) {
                    case 'healthy':
                      return '🌿 Sehat';
                    case 'needs_water':
                      return '💧 Perlu Disiram';
                    case 'attention':
                      return '⚠️ Perlu Perhatian';
                    default:
                      return status;
                  }
                },
                onChanged: (value) => setState(() => _selectedStatus = value!),
                textColor: textColor,
                inputBgColor: inputBgColor,
                borderColor: borderColor,
              ),
              const SizedBox(height: 16),

              // Light & Humidity Row
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Cahaya',
                      value: _selectedLight,
                      items: _lightOptions,
                      onChanged: (value) =>
                          setState(() => _selectedLight = value!),
                      textColor: textColor,
                      inputBgColor: inputBgColor,
                      borderColor: borderColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Kelembaban',
                      value: _selectedHumidity,
                      items: _humidityOptions,
                      onChanged: (value) =>
                          setState(() => _selectedHumidity = value!),
                      textColor: textColor,
                      inputBgColor: inputBgColor,
                      borderColor: borderColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Watering Interval & Age Row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _wateringIntervalController,
                      label: 'Interval Siram (hari)',
                      hint: '7',
                      textColor: textColor,
                      inputBgColor: inputBgColor,
                      borderColor: borderColor,
                      isDarkMode: isDarkMode,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _ageController,
                      label: 'Umur (bulan)',
                      hint: '1',
                      textColor: textColor,
                      inputBgColor: inputBgColor,
                      borderColor: borderColor,
                      isDarkMode: isDarkMode,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _savePlant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: const Color(0xFF0F172A),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.plant != null
                        ? 'Perbarui Tanaman'
                        : 'Tambah Tanaman',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              if (widget.plant != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Hapus Tanaman'),
                          content: Text(
                            'Apakah Anda yakin ingin menghapus ${widget.plant!.name}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                _plantService.deletePlant(widget.plant!.id);
                                Navigator.pop(context); // Close dialog
                                Navigator.pop(context, true); // Return to home
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tanaman berhasil dihapus'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                              child: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Hapus Tanaman',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Color textColor,
    required Color inputBgColor,
    required Color borderColor,
    required bool isDarkMode,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDarkMode
                  ? const Color(0xFF64748B)
                  : const Color(0xFF94A3B8),
            ),
            filled: true,
            fillColor: inputBgColor,
            contentPadding: const EdgeInsets.all(16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required Color textColor,
    required Color inputBgColor,
    required Color borderColor,
    String Function(String)? displayText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: inputBgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: inputBgColor,
            style: TextStyle(color: textColor),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(displayText?.call(item) ?? item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
