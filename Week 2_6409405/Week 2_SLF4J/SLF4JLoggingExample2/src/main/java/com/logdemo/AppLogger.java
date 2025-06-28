package com.logdemo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AppLogger {
    private static final Logger logger = LoggerFactory.getLogger(AppLogger.class);

    public static void main(String[] args) {
        logger.info("INFO: Application started.");
        logger.debug("DEBUG: Running in debug mode.");
        logger.warn("WARNING: Low disk space.");
        logger.error("ERROR: Null pointer exception simulation.");

        System.out.println("Logging complete. Check the console for SLF4J output.");
    }
}
