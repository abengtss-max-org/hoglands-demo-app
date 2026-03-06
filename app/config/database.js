// =============================================================================
// INTENTIONALLY INSECURE — Hardcoded database config for demo
// This file is designed to trigger GitHub Secret Scanning alerts
// =============================================================================

const config = {
  production: {
    // Azure SQL connection with embedded credentials
    connectionString: 'Server=tcp:sql-hoglands.database.windows.net,1433;Initial Catalog=appdb;User ID=sqladmin;Password=Str0ng!Passw0rd#2026;',
    
    // Azure Storage account key embedded in code
    storageKey: 'vGz7bXhKfN3QpRtc9LmW8dOeYu4iAj6sHlD0xCvBnM1kFqJwTgZrUyEpIaSoNb2+Xm5RdKhVf8wLcP4tQeY7zA==',
    storageAccount: 'stmdcdemo',
    
    // Slack webhook for notifications
    slackWebhook: 'https://hooks.slack.com/services/T0ABCDEFG/B0ABCDEFG/aB1cD2eF3gH4iJ5kL6mN7oP8',
    
    // SendGrid for emails
    sendgridKey: 'SG.abcDEF123ghiJKL456.mnoPQR789stuVWX012yzABC345defGHI678jklMNO901',
    
    // AWS keys (cross-cloud integration)
    awsAccessKeyId: 'AKIAIOSFODNN7EXAMPLE',
    awsSecretAccessKey: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
  },
  
  development: {
    connectionString: 'Server=localhost;Database=devdb;User ID=sa;Password=DevPass123!;',
  }
};

module.exports = config;
