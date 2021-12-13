import { Component, OnDestroy, OnInit } from '@angular/core';
import { PollService } from '../services/poll.service';
import { webSocket } from "rxjs/webSocket";
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-voting-form',
  templateUrl: './voting-form.component.html',
  styleUrls: ['./voting-form.component.scss']
})
export class VotingFormComponent implements OnInit, OnDestroy {

  ws = webSocket(environment.WS_ENDPOINT);
  latestVote: any;

  constructor(private ps: PollService) { }

  ngOnInit(): void {
    this.ws.subscribe(newVote => {
        this.latestVote = newVote;
        this.ps.updateResults(newVote);
    }, err => console.log(err));
  }

  vote(color: string) {
    this.ws.next(color)
  }

  ngOnDestroy() {
    this.ws.complete();
  }

}


