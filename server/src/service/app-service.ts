import { Provide } from '@midwayjs/decorator';
import * as moment from 'moment';
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
      const searchResult: StatisticsInfo[] = await new Promise((resolve) => {
        connection.execute('SELECT * FROM `temp_hum` WHERE `client_id` = ?', [clientId], (err, results, fields) => {
          resolve(results as StatisticsInfo[]);
        });
      });

      const humidAverage =
        searchResult.reduce((previousValue, currentValue) => {
          return previousValue + currentValue.hum;
        }, 0) / searchResult.length;

      const tempAverage =
        searchResult.reduce((previousValue, currentValue) => {
          return previousValue + currentValue.temp;
        }, 0) / searchResult.length;

      const findTargetFromSearchResult = (target: number) => {
        return searchResult.find((item) => {
          let t = moment(item.up_timestamp).set('minute', 0).set('second', 0).set('millisecond', 0);
          return t.toDate().getTime() === target;
        });
      };

      const current = moment().set('minute', 0).set('second', 0).set('millisecond', 0).subtract(24, 'hour');
      const arr = new Array(24).fill('').map(() => {
        return current.add(1, 'hour').toDate().getTime();
      });

      return arr.map((item) => {
        return {
          up_timestamp: item,
          hum: findTargetFromSearchResult(item)?.hum || humidAverage,
          temp: findTargetFromSearchResult(item)?.temp || tempAverage,
          client_id: '13',
          id: 22,
        };
      });
    }
    return [];
  }
}
