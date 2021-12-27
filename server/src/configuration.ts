import { Configuration, App } from '@midwayjs/decorator';
import { Application } from '@midwayjs/koa';
import * as bodyParser from 'koa-bodyparser';
import * as path from 'path';
import * as orm from '@midwayjs/orm';

@Configuration({
  conflictCheck: true,
  imports: [orm],
  importConfigs: [path.join(__dirname, './config/')],
})
export class ContainerLifeCycle {
  @App()
  app: Application;

  async onReady() {
    this.app.use(bodyParser());
  }
}
