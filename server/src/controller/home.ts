import { Controller, Get, Inject, Provide, Query } from '@midwayjs/decorator';
import { AppService } from '../service/app-service';

@Provide()
@Controller('/')
export class HomeController {
  @Inject()
  appService: AppService;

  @Get('/')
  async home() {
    return {
      code: 0,
      message: '🎉 The project is running successfully!',
      data: {},
    };
  }

  @Get('/get-statistics')
  async getStatistics(@Query() clientId: string) {
    const res = await this.appService.getStatistics(clientId);
    return {
      code: 0,
      message: 'ok',
      data: res,
    };
  }
}
