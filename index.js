import { build_app } from "@gridql/server";

import { parse } from "@gridql/server/lib/config.js";
import fs from "fs";
import Log4js from "log4js";
import { valid } from "@gridql/payload-validator";
import { JWTSubAuthorizer } from "@gridql/auth";

Log4js.configure({
    appenders: {
        out: {
            type: "stdout",
        },
    },
    categories: {
        default: { appenders: ["out"], level: "info" },
    },
});

let logger = Log4js.getLogger("gridql/repository");

let configPath = "./config/config.conf";
if (fs.existsSync(configPath)) {
    parse(configPath, JWTSubAuthorizer)
        .then((config) => {
            for (let r of config.restlettes) {
                r.validator = valid(r.schema);
                r.authorizer = JWTSubAuthorizer;
            }
            logger.info(`Graphlettes: ${config.graphlettes.length}`);
            logger.info(`Restlettes: ${config.restlettes.length}`);
            build_app(config).then((app) => app.listen(config.port));
        })
        .catch((err) => logger.error(`Error parsing config: ${err}`));
} else {
    logger.error("Config missing");
}
