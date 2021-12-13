import { Injectable } from '@angular/core';
import { Subject } from 'rxjs';
import { environment } from 'src/environments/environment';
import { HttpClient } from '@angular/common/http';


@Injectable({
  providedIn: 'root'
})
export class PollService {

    API_ENDPOINT = environment.API_ENDPOINT;
    fullPollResults = new Subject<any>();
    pollResults: any;
    constructor(private http: HttpClient) {}

    getFullResults() {
        return this.http.get(`${this.API_ENDPOINT}/poll-results`).subscribe(pollResults => {
            this.pollResults = pollResults;
            this.fullPollResults.next(pollResults)
        })
    }

    updateResults(lastestVote: any) {
        this.pollResults = this.pollResults.map((e:any) => {
            if(e.color == lastestVote) {
                e.votes++
            }
            return e
        })
        this.fullPollResults.next(this.pollResults)
    }


}