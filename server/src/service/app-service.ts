import { Provide } from '@midwayjs/decorator';
import { connection } from '../config/connection';

/**
 * 所有业务
 *
 * @author yuzhanglong
 * @date 2021-12-13 18:37:05
 */
@Provide()
export class AppService {
  async getStatistics(clientId: string): Promise<StatisticsInfo[]> {
    // esp8266-30:83:98:A4:F7:6F
    if (clientId) {
      const res = await new Promise((resolve) => {
        connection.execute('SELECT * FROM `temp_hum` WHERE `client_id` = ?', [clientId], (err, results, fields) => {
          resolve(results);
        });
      });
      return (res as StatisticsInfo[]).map((item) => {
        return {
          ...item,
          up_timestamp: new Date(item['up_timestamp']).getTime(),
        };
      });
    }
    return [];
  }
}
