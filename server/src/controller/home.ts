import { Controller, Get, Provide } from '@midwayjs/decorator';

@Provide()
@Controller('/')
export class HomeController {
  @Get('/')
  async home(): Promise<string> {
    return '🎉 The project is running successfully!';
  }
}
