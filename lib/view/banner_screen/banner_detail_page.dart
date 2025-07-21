import 'package:flutter/material.dart' hide Banner;
import 'package:deepuadmin/services/api_service.dart';
import 'package:deepuadmin/model/banner_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannerDetailPage extends StatefulWidget {
  final int bannerId;
  final Banner? initialBanner;

  const BannerDetailPage({
    Key? key,
    required this.bannerId,
    this.initialBanner,
  }) : super(key: key);

  @override
  State<BannerDetailPage> createState() => _BannerDetailPageState();
}

class _BannerDetailPageState extends State<BannerDetailPage> {
  late Future<Map<String, dynamic>> _bannerFuture;
  bool _isLoading = false;
  bool _currentStatus = false;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _bannerFuture = ApiService.getBannerById(widget.bannerId);
  }

  Future<void> _updateBannerStatus(bool newStatus) async {
    setState(() => _isLoading = true);
    try {
      await ApiService.updateBanner(
        widget.bannerId,
        status: newStatus,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Banner status updated successfully')),
        );
        setState(() {
          _currentStatus = newStatus;
          // Refresh the banner data after successful update
          _bannerFuture = ApiService.getBannerById(widget.bannerId);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating banner status: $e')),
        );
        // Revert the status on error
        setState(() {
          _currentStatus = !newStatus;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showDeleteConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Banner'),
          content: const Text('Are you sure you want to delete this banner?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteBanner();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBanner() async {
    setState(() => _isLoading = true);
    try {
      await ApiService.deleteBanner(widget.bannerId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Banner deleted successfully')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting banner: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildBannerImage(Banner banner) {
    print('Loading image from URL: ${banner.fullImageUrl}'); // Debug print
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: banner.fullImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) {
            print('Error loading image: $error for URL: $url'); // Debug print
            return Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banner #${widget.bannerId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : _showDeleteConfirmation,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _bannerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !_hasInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final banner = snapshot.hasData ? Banner.fromJson(snapshot.data!) : null;

          if (banner == null) {
            return const Center(child: Text('No banner data available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBannerImage(banner),
                const SizedBox(height: 24),
                
                // Status Switch
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Banner Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              banner.status ? 'Active' : 'Inactive',
                              style: TextStyle(
                                color: banner.status ? Colors.green : Colors.red,
                                fontSize: 16,
                              ),
                            ),
                            Switch(
                              value: banner.status,
                              onChanged: _isLoading
                                  ? null
                                  : (bool value) => _updateBannerStatus(value),
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
