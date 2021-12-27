import * as mysql from 'mysql2';

export const connection = mysql.createConnection({
  host: '118.31.246.213',
  port: 3306,
  user: 'aliyun_syt',
  password: '745719',
  database: 'aliyun_syt',
});
