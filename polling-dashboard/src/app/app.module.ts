import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { PollResultsComponent } from './poll-results/poll-results.component';
import { VotingFormComponent } from './voting-form/voting-form.component';
import { MaterialModule } from './material.module';
import { FlexLayoutModule } from '@angular/flex-layout';

import * as PlotlyJS from 'plotly.js-dist-min';
import { PlotlyModule } from 'angular-plotly.js';
import { PollService } from './services/poll.service';

PlotlyModule.plotlyjs = PlotlyJS;


@NgModule({
  declarations: [
    AppComponent,
    PollResultsComponent,
    VotingFormComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    MaterialModule,
    PlotlyModule,
    HttpClientModule,
    FlexLayoutModule
  ],
  providers: [PollService],
  bootstrap: [AppComponent]
})
export class AppModule { }
