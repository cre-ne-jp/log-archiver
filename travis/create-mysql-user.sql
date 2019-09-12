CREATE USER 'log_archiver'@'localhost' IDENTIFIED BY 'log_archiver';
GRANT ALL ON log_archiver_test.* TO 'log_archiver'@'localhost';
