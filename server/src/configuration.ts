import { Configuration, App, Inject } from '@midwayjs/decorator';
import { Application } from '@midwayjs/koa';
import * as bodyParser from 'koa-bodyparser';
import { CacheManager } from '@midwayjs/cache';
import * as path from 'path';

@Configuration({
  conflictCheck: true,
  importConfigs: [path.join(__dirname, './config/')],
})
export class ContainerLifeCycle {
  @App()
  app: Application;

  @Inject()
  cache: CacheManager;

  async onReady() {
    this.app.use(bodyParser());
  }
}
