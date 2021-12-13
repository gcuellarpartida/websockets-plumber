import { Component, OnDestroy, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';
import { PollService } from '../services/poll.service';

@Component({
  selector: 'app-poll-results',
  templateUrl: './poll-results.component.html',
  styleUrls: ['./poll-results.component.scss']
})
export class PollResultsComponent implements OnInit, OnDestroy {

  constructor(private ps: PollService) { }
  pollResultsSubs!: Subscription;
  data = [
    {
      x: [],
      y: [],
      type: 'bar'
    }
  ];
  ngOnInit(): void {
    this.pollResultsSubs = this.ps.fullPollResults.subscribe(results => {
      this.data = [
        {
          x: results.map((e:any) => e.color),
          y: results.map((e:any) => e.votes),
          type: 'bar'
        }
      ];
    });
    this.ps.getFullResults();
  }

  ngOnDestroy() {
    this.pollResultsSubs.unsubscribe();
  }


}
