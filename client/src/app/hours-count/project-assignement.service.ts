import { Injectable } from '@angular/core';
import { DBService } from './../db/db.service';
import { map } from 'rxjs/operators';

@Injectable()
export class ProjectAssignementService {

  /**
   * 
   * @param dbService The DB service to communicate with the Database service.
   */
  constructor(private dbService: DBService) { }

  /**
   * Return the list of affected projects.
   * @param userId The user id we want the project affected to.
   */
  listProjectAffectedTo(userId: number, filter = {}) {
    filter['user.id'] = userId;
    return this.dbService.list("project_assignements", filter).pipe(map((items) => {
      for (var i = 0; i < items.length; i++) {
        items[i] = items[i].project;
      }
      return items;
    }));
  }

  /**
   * Return the list of affected clients (deduced from affected projects)
   * @param userId The user id we want the clients affected to.
   */
  listClientAffectedTo(userId: number, filter = {}) {
    filter['user_id'] = userId;
    return this.dbService.list("clients_affected_to_users", filter);
  }
}
