CREATE OR REPLACE FUNCTION willy.update_all_groups_to_inactive() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
	update willy.intervals_group set is_active = false where is_active;
	RETURN NEW;
END;
$$;

CREATE TRIGGER do_all_groups_inactive BEFORE INSERT ON willy.intervals_group
FOR EACH ROW
WHEN (NEW.is_active)
EXECUTE PROCEDURE willy.update_all_groups_to_inactive();

CREATE UNIQUE INDEX led_intervals_group_n_led_ids_uidx ON willy.led_intervals (group_id, led_id);
CREATE UNIQUE INDEX sensor_intervals_group_id_uidx ON willy.sensor_intervals (group_id);
CREATE UNIQUE INDEX sensor_description_position_n_active ON willy.sensor_description (data_position_in_dataset) WHERE (is_active);

CREATE INDEX sensor_data_group_id_idx ON willy.sensor_data (intervals_group);
CREATE INDEX start_stop_intervals_group_id_idx ON willy.start_stop_intervals (group_id);
