import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For copying to clipboard
import 'package:pics/src/models/bank_model.dart';
import 'package:pics/src/blocs/programs_provider.dart';
import "package:pics/src/blocs/programs_bloc.dart";
import 'package:pics/src/screens/home_screen.dart';
class PaymentMethodDialog extends StatefulWidget {
  final VoidCallback onClose;
  final String programId; // Add the programId as a parameter

  PaymentMethodDialog({required this.onClose, required this.programId});

  @override
  _PaymentMethodDialogState createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
  BankModel? _selectedBank;
  final TextEditingController _referenceController = TextEditingController();
  bool _isPaidButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _referenceController.addListener(_validateReferenceNumber);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = ProgramsProvider.of(context);
    bloc.fetchBanks();
  }

  void _validateReferenceNumber() {
    setState(() {
      _isPaidButtonEnabled = _referenceController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _referenceController.dispose();
    super.dispose();
  }

  void _onBankSelected(BankModel bank) {
    setState(() {
      _selectedBank = bank;
    });
  }

  void _copyAccountNumber(String accountNumber) {
    Clipboard.setData(ClipboardData(text: accountNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account number copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ProgramsProvider.of(context);

    return StreamBuilder<List<BankModel>>(
      stream: bloc.getBanks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingDialog();
        } else if (snapshot.hasError) {
          return _buildErrorDialog(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoBanksDialog();
        } else {
          return _selectedBank == null
              ? _buildBankSelectionDialog(snapshot.data!)
              : _buildPaymentConfirmationDialog(context, bloc);
        }
      },
    );
  }

  Widget _buildLoadingDialog() {
    return AlertDialog(
      title: Text('Choose a Payment Method'),
      content: Center(child: CircularProgressIndicator()),
      actions: [
        TextButton(
          onPressed: widget.onClose,
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _buildErrorDialog(String error) {
    return AlertDialog(
      title: Text('Error'),
      content: Text('Failed to fetch banks: $error'),
      actions: [
        TextButton(
          onPressed: widget.onClose,
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _buildNoBanksDialog() {
    return AlertDialog(
      title: Text('No Banks Available'),
      content: Text('No payment methods available.'),
      actions: [
        TextButton(
          onPressed: widget.onClose,
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _buildBankSelectionDialog(List<BankModel> banks) {
    return AlertDialog(
      title: Text('Choose a Payment Method'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: banks.length,
          itemBuilder: (context, index) {
            final bank = banks[index];
            return ListTile(
              leading: Image.network(bank.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(bank.name),
              subtitle: Text(bank.accountNumber),
              onTap: () => _onBankSelected(bank),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: widget.onClose,
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _buildPaymentConfirmationDialog(BuildContext context, ProgramsBloc bloc) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text('Payment Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(_selectedBank!.imageUrl, width: 100, height: 100, fit: BoxFit.cover),
          SizedBox(height: 8.0),
          Text(_selectedBank!.name, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(child: Text('Account Number: ${_selectedBank!.accountNumber}')),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () => _copyAccountNumber(_selectedBank!.accountNumber),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: _referenceController,
            decoration: InputDecoration(
              labelText: 'Reference Number',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onClose,
          child: Text('Close'),
        ),
        ElevatedButton(
          onPressed: _isPaidButtonEnabled ? () => _onPaid(bloc) : null,
          style: ElevatedButton.styleFrom(
            primary: theme.primaryColor, // Set button background to primary color
          ),
          child: Text(
            'Paid',
            style: TextStyle(color: Colors.white), // Set button text color to white
          ),
        ),
      ],
    );
  }
void _onPaid(ProgramsBloc bloc) {
  // Enroll in the program
  bloc.enrollProgram(widget.programId);

  // Debugging print statements
  print('Program ID: ${widget.programId}');
  print('Navigating to: /home');

  // Close the dialog first
  Navigator.of(context).pop();

  // Show a confirmation dialog
  Future.delayed(Duration(milliseconds: 100), () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enrollment Confirmation'),
        content: Text('You have been successfully enrolled in this program.'),
        actions: [
          TextButton(
            onPressed: () {
              bloc.setEnrolled();
              Navigator.of(context).pop(); // Close the confirmation dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  });
}

}
