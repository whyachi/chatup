// Aggregator for all ChatUp custom module routes.
// Every new module adds its route import here; upstream merges do not touch this file.
import { routes as boilerplateRoutes } from './boilerplate/boilerplate.routes';

export const routes = [...boilerplateRoutes];
