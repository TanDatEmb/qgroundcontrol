import os
import sys
import glob
import pandas as pd
import numpy as np
from pyulog import ULog
import plotly.graph_objects as go
from scipy.fft import rfft, rfftfreq
from scipy import signal

PLOTS_CONFIG = {
    "Altitude_Estimate": {
        "title": "Altitude Estimate Analysis",
        "ylabel": "(m)",
        "setpoint_style": "marker",
        "series": {
            "GPS Altitude (MSL)": ("vehicle_gps_position", "altitude_msl_m"),
            "Barometer Altitude": ("vehicle_air_data", "baro_alt_meter"),
            "Fused Altitude Estimation": ("vehicle_global_position", "alt"),
            "Altitude Setpoint": ("position_setpoint_triplet", "current.alt")
        }
    },
    "Roll_Angle": {
        "title": "Roll Angle",
        "ylabel": "(deg)",
        "setpoint_style": "step",
        "series": {
            "Roll Estimated": ("vehicle_attitude", "roll"),
            "Roll Setpoint": ("vehicle_attitude_setpoint", "roll_d")
        }
    },
    "Roll_Angular_Rate": {
        "title": "Roll Angular Rate",
        "ylabel": "(deg/s)",
        "convert_rad_to_deg": True,
        "setpoint_style": "step",
        "series": {
            "Roll Rate Estimated": ("vehicle_angular_velocity", "xyz[0]"),
            "Roll Rate Setpoint": ("vehicle_rates_setpoint", "roll"),
            "Roll Rate Integral": ("rate_ctrl_status", "rollspeed_integ")
        }
    },
    "Pitch_Angle": {
        "title": "Pitch Angle",
        "ylabel": "(deg)",
        "setpoint_style": "step",
        "series": {
            "Pitch Estimated": ("vehicle_attitude", "pitch"),
            "Pitch Setpoint": ("vehicle_attitude_setpoint", "pitch_d")
        }
    },
    "Pitch_Angular_Rate": {
        "title": "Pitch Angular Rate",
        "ylabel": "(deg/s)",
        "convert_rad_to_deg": True,
        "setpoint_style": "step",
        "series": {
            "Pitch Rate Estimated": ("vehicle_angular_velocity", "xyz[1]"),
            "Pitch Rate Setpoint": ("vehicle_rates_setpoint", "pitch"),
            "Pitch Rate Integral": ("rate_ctrl_status", "pitchspeed_integ")
        }
    },
    "Yaw_Angle": {
        "title": "Yaw Angle",
        "ylabel": "(deg)",
        "setpoint_style": "step",
        "series": {
            "Yaw Estimated": ("vehicle_attitude", "yaw"),
            "Yaw Setpoint": ("vehicle_attitude_setpoint", "yaw_d")
        }
    },
    "Yaw_Angular_Rate": {
        "title": "Yaw Angular Rate",
        "ylabel": "(deg/s)",
        "convert_rad_to_deg": True,
        "setpoint_style": "step",
        "series": {
            "Yaw Rate Estimated": ("vehicle_angular_velocity", "xyz[2]"),
            "Yaw Rate Setpoint": ("vehicle_rates_setpoint", "yaw"),
            "Yaw Rate Integral": ("rate_ctrl_status", "yawspeed_integ")
        }
    },
    "Local_Position_X": {
        "title": "Local Position X",
        "ylabel": "(m)",
        "setpoint_style": "marker",
        "series": {
            "X Estimated": ("vehicle_local_position", "x"),
            "X Setpoint": ("vehicle_local_position_setpoint", "x")
        }
    },
    "Local_Position_Y": {
        "title": "Local Position Y",
        "ylabel": "(m)",
        "setpoint_style": "marker",
        "series": {
            "Y Estimated": ("vehicle_local_position", "y"),
            "Y Setpoint": ("vehicle_local_position_setpoint", "y")
        }
    },
    "Local_Position_Z": {
        "title": "Local Position Z",
        "ylabel": "(m)",
        "setpoint_style": "marker",
        "series": {
            "Z Estimated": ("vehicle_local_position", "z"),
            "Z Setpoint": ("vehicle_local_position_setpoint", "z")
        }
    },
    "Velocity": {
        "title": "Velocity",
        "ylabel": "(m/s)",
        "setpoint_style": "step",
        "series": {
            "X": ("vehicle_local_position", "vx"),
            "Y": ("vehicle_local_position", "vy"),
            "Z": ("vehicle_local_position", "vz"),
            "X Setpoint": ("vehicle_local_position_setpoint", "vx"),
            "Y Setpoint": ("vehicle_local_position_setpoint", "vy"),
            "Z Setpoint": ("vehicle_local_position_setpoint", "vz")
        }
    },
    "Manual Control Inputs (Radio or Joystick)": {
        "title": "Velocity",
        "ylabel": "",
        "setpoint_style": "step",
        "series": {
            "Y / Roll": ("manual_control_setpoint", "roll"),
            "X / Pitch": ("manual_control_setpoint", "pitch"),
            "Z / Yaw": ("manual_control_setpoint", "yaw"),
            "Throttle [-1, 1]": ("manual_control_setpoint", "throttle"),
            "Aux 1": ("manual_control_setpoint", "aux1"),
            "Aux 2": ("manual_control_setpoint", "aux2"),
            "Flight Mode": ("manual_control_switches", "mode_slot"),
            "Kill Switch": ("manual_control_switches", "kill_switch")
        }
    },
    "Actuator_Controls": {
        "title": "Actuator Controls",
        "ylabel": "",
        "setpoint_style": "step",
        "series": {
            "Roll": ("actuator_outputs", "roll_calc"),
            "Pitch": ("actuator_outputs", "pitch_calc"),
            "Yaw": ("actuator_outputs", "yaw_calc"),
            "Thrust (up)": ("actuator_outputs", "thrust_up_calc"),
            "Thrust (forward)": ("actuator_outputs", "thrust_forward")
        }
    },
    "Actuator_Controls_FFT": {
        "title": "Actuator Controls FFT",
        "setpoint_style": "fft",
        "series": {
            "Roll": ("actuator_outputs", "roll_fft"),
            "Pitch": ("actuator_outputs", "pitch_fft"),
            "Yaw": ("actuator_outputs", "yaw_fft"),
        }
    },
    "Angular_Velocity_FFT": {
        "title": "Angular Velocity FFT",
        "setpoint_style": "fft",
        "series": {
            "Rollspeed": ("vehicle_angular_velocity", "rollrate_fft"),
            "Pitchspeed": ("vehicle_angular_velocity", "pitchrate_fft"),
            "Yawspeed": ("vehicle_angular_velocity", "yawrate_fft"),
        }
    },
    "Motor_Outputs": {
        "title": "Motor Outputs",
        "ylabel": "",
        "setpoint_style": "step",
        "series": {
            "Motor 1": ("actuator_outputs", "m0_norm"),
            "Motor 2": ("actuator_outputs", "m1_norm"),
            "Motor 3": ("actuator_outputs", "m2_norm"),
            "Motor 4": ("actuator_outputs", "m3_norm")
        }
    },
    "Raw_Acceleration": {
        "title": "Raw Acceleration",
        "ylabel": "(m/s^2)",
        "setpoint_style": "step",
        "series": {
            "X": ("sensor_combined", "accelerometer_m_s2[0]"),
            "Y": ("sensor_combined", "accelerometer_m_s2[1]"),
            "Z": ("sensor_combined", "accelerometer_m_s2[2]")
        }
    },
    "Vibration_Metrics": {
        "title": "Vibration Metrics",
        "ylabel": "",
        "setpoint_style": "step",
        "series": {
            "Accel 0 Vibration Level (m/s^2)": ("vehicle_imu_status", "accel0_vibration"),
            "Accel 1 Vibration Level (m/s^2)": ("vehicle_imu_status", "accel1_vibration"),
            "Accel 2 Vibration Level (m/s^2)": ("vehicle_imu_status", "accel2_vibration")
        }
    },
    "Acceleration_Power_Spectral_Density": {
        "title": "Acceleration Power Spectral Density",
        "setpoint_style": "psd",
        "series": {
            "X": ("sensor_combined", "accelerometer_m_s2[0]"),
            "Y": ("sensor_combined", "accelerometer_m_s2[1]"),
            "Z": ("sensor_combined", "accelerometer_m_s2[2]")
        }
    },
    "Angular_Velocity_Power_Spectral_Density": {
        "title": "Angular Velocity Power Spectral Density",
        "setpoint_style": "psd",
        "series": {
            "Roll": ("vehicle_angular_velocity", "xyz[0]"),
            "Pitch": ("vehicle_angular_velocity", "xyz[1]"),
            "Yaw": ("vehicle_angular_velocity", "xyz[2]")
        }
    },
    "Raw_Angular_Speed_(Gyroscope)": {
        "title": "Raw Angular Speed (Gyroscope)",
        "ylabel": "(deg/s)",
        "setpoint_style": "step",
        "series": {
            "X": ("sensor_combined", "gyro_rad[0]"),
            "Y": ("sensor_combined", "gyro_rad[1]"),
            "Z": ("sensor_combined", "gyro_rad[2]")
        }
    },
    "Raw_Magnetic_Field_Strength": {
        "title": "Raw Magnetic Field Strength",
        "ylabel": "(gauss)",
        "setpoint_style": "step",
        "series": {
            "X": ("vehicle_magnetometer", "magnetometer_ga[0]"),
            "Y": ("vehicle_magnetometer", "magnetometer_ga[1]"),
            "Z": ("vehicle_magnetometer", "magnetometer_ga[2]")
        }
    },
    "Distance_Sensor": {
        "title": "Distance Sensor",
        "ylabel": "(m)",
        "setpoint_style": "step",
        "series": {
            "Estimated Distance Bottom": ("vehicle_local_position", "dist_bottom"),
            "Dist Bottom Valid": ("vehicle_local_position", "dist_bottom_valid")
        }
    },
    "GPS_Uncertainty": {
        "title": "GPS Uncertainty",
        "ylabel": "",
        "setpoint_style": "step",
        "series": {
            "Horizontal position accuracy (m)": ("vehicle_gps_position", "eph"),
            "Vertical position accuracy (m)": ("vehicle_gps_position", "epv"),
            "Horizontal dilution of precision": ("vehicle_gps_position", "hdop"),
            "Vertical dilution of precision": ("vehicle_gps_position", "vdop"),
            "Speed accuracy (m/s)": ("vehicle_gps_position", "s_variance_m_s"),
            "Num Satellites used": ("vehicle_gps_position", "satellites_used"),
            "GPS Fix": ("vehicle_gps_position", "fix_type")
        }
    },
    "GPS_Noise_&_Jamming": {
        "title": "GPS Noise & Jamming",
        "ylabel": "",
        "setpoint_style": "step",
        "series": {
            "Noise per ms": ("sensor_gps", "noise_per_ms"),
            "Jamming Indicator": ("sensor_gps", "jamming_indicator")
        }
    },
    "Thrust_and_Magnetic_Feild": {
        "title": "Thrust and Magnetic Feild",
        "ylabel": "",
        "setpoint_style": "step",
        "series": {
            "Normal of Magnetic Field": ("vehicle_magnetometer", "norm_magnetometer"),
            "Thrust": ("actuator_outputs", "thrust_up_calc")
        }
    },
    "Power": {
        "title": "Power",
        "ylabel": "",
        "setpoint_style": "step",
        "series": {
            "Battery Voltage (V)": ("battery_status", "voltage_v"),
            "Battery Current (A)": ("battery_status", "current_a"),
            "Discharged Amount (mAh / 100)": ("battery_status", "discharged_mah"),
            "Battery remaining (0=empty, 10=full)": ("battery_status", "remaining"),
            "5 V": ("system_power", "voltage5v_v")
        }
    },
    "Temperature": {
        "title": "Temperature",
        "ylabel": "(C)",
        "setpoint_style": "step",
        "series": {
            "Accel temperature": ("sensor_accel", "mean_temperature"),
            "Battery temperature": ("battery_status", "temperature")
        }
    },
    "Estimator_Flags": {
        "title": "Estimator Flags",
        "ylabel": "",
        "setpoint_style": "step",
        "series": {
            "Mag X,Y,Z Check Bits": ("estimator_status_flags", "cs_mag_field_disturbed")
        }
    },
    "Failsafe_Flags": {
        "title": "Failsafe Flags",
        "ylabel": "",
        "setpoint_style": "step",
        "series": {
            "In Failsafe": ("failsafe_flags", "manual_control_signal_lost"),
            "User Took Over": ("failsafe_flags", "manual_control_signal_lost"),
            "Battery Warning": ("failsafe_flags", "battery_warning")
        }
    },
    "CPU_&_RAM": {
        "title": "CPU & RAM",
        "ylabel": "",
        "setpoint_style": "step",
        "series": {
            "RAM Usage": ("cpuload", "ram_usage"),
            "CPU Load": ("cpuload", "load")
        }
    },
    "Sampling_Regularity_of_Sensor_Data": {
        "title": "Sampling Regularity of Sensor Data",
        "ylabel": "(µs)",
        "setpoint_style": "step",
        "series": {
            "Delta t (btw 2 logged samples)": ("sensor_combined", "delta_t"),
            "Estimator time slip (cumulative)": ("estimator_status", "time_slip")
        }
    }
}

# Mean Max Min Deviation
def calculate_statistics(data_points):
    if not data_points:
        return {}
    values = [p[1] for p in data_points]
    series = pd.Series(values)
    return {
        "Mean": series.mean(),
        "Max": series.max(),
        "Min": series.min(),
        "Std Dev": series.std()
    }
    
def quaternion_to_euler_deg(q):
    w, x, y, z = q
    sinr_cosp = 2 * (w * x + y * z)
    cosr_cosp = 1 - 2 * (x * x + y * y)
    roll = np.arctan2(sinr_cosp, cosr_cosp)
    sinp = 2 * (w * y - z * x)
    if abs(sinp) >= 1:
        pitch = np.copysign(np.pi / 2, sinp)
    else:
        pitch = np.arcsin(sinp)
    siny_cosp = 2 * (w * z + x * y)
    cosy_cosp = 1 - 2 * (y * y + z * z)
    yaw = np.arctan2(siny_cosp, cosy_cosp)
    return np.rad2deg(roll), np.rad2deg(pitch), np.rad2deg(yaw)

def process_attitude_topic(ulog_object, topic_name):
    try:
        topic_data = next(d for d in ulog_object.data_list if d.name == topic_name)
        df = pd.DataFrame(topic_data.data)
        
        if 'q[0]' in df.columns:
            euler_angles = df[['q[0]', 'q[1]', 'q[2]', 'q[3]']].apply(
                lambda row: quaternion_to_euler_deg(row), axis=1, result_type='expand'
            )
            euler_angles.columns = ['roll', 'pitch', 'yaw']
            df = pd.concat([df, euler_angles], axis=1)
        elif 'q_d[0]' in df.columns:
            euler_angles = df[['q_d[0]', 'q_d[1]', 'q_d[2]', 'q_d[3]']].apply(
                lambda row: quaternion_to_euler_deg(row), axis=1, result_type='expand'
            )
            euler_angles.columns = ['roll_d', 'pitch_d', 'yaw_d']
            df = pd.concat([df, euler_angles], axis=1)
        
        print(f"  + Converted Quaternions to Euler Angles for '{topic_name}'")
        
        return df
    except (StopIteration, KeyError):
        print(f"  - Warning: Could not find or process topic '{topic_name}'.")
        return None

# Need to check
def calculate_abstract_controls_from_outputs(ulog_object):
    try:
        topic_data = next(d for d in ulog_object.data_list if d.name == 'actuator_outputs' and d.multi_id == 0)
        df = pd.DataFrame(topic_data.data)

        df['timestamp_sec'] = df['timestamp'] / 1E6

        # 1500 - 500 for bidirectional
        # 1000 - 1000 for unidirectional
        for i in range(4):
            df[f'm{i}_norm'] = (df[f'output[{i}]'] - 1000) / 1000
            
        df['m3_norm'] = (df['output[3]'] - 1000) / 1000

        m0 = df['m0_norm']
        m1 = df['m1_norm']
        m2 = df['m2_norm']
        m3 = df['m3_norm']

        df['roll_calc'] = (m1+m2-m0-m3) / 2.0
        df['pitch_calc'] = (-m1-m3+m0+m2) / 2.0
        df['yaw_calc'] = (m2+m3-m0-m1) / 2.0
        df['thrust_up_calc'] = (df['m0_norm'] + df['m1_norm'] + df['m2_norm'] + df['m3_norm']) / 4.0
        df['thrust_forward'] = 0
        # df['roll_calc'] = df['m0_norm']
        # df['pitch_calc'] = df['m1_norm']
        # df['yaw_calc'] = df['m2_norm']
        # df['thrust_up_calc'] = df['m3_norm']
        
        print("    -> Successfully reverse-calculated abstract controls from outputs.")

        return df[['timestamp_sec', 'roll_calc', 'pitch_calc', 'yaw_calc', 'thrust_up_calc', 'thrust_forward', 'm0_norm', 'm1_norm', 'm2_norm', 'm3_norm']]

    except Exception as e:
        print(f"  - Error calculating abstract controls: {e}")
        return None

def accel_vibration_metrics(ulog_object):
    try:
        all_dfs = []
        for i in range(3):
            try:
                topic_data = next(d for d in ulog_object.data_list if d.name == 'vehicle_imu_status' and d.multi_id == i)
                temp_df = pd.DataFrame(topic_data.data)
                
                temp_df = temp_df[['timestamp', 'accel_vibration_metric']]
                temp_df.rename(columns={'accel_vibration_metric': f'accel{i}_vibration'}, inplace=True)
                all_dfs.append(temp_df)
            except StopIteration:
                continue

        df_merged = pd.merge(all_dfs[0], all_dfs[1], on='timestamp', how='outer')
        df_merged = pd.merge(df_merged, all_dfs[2], on='timestamp', how='outer')

        df_merged.sort_values(by='timestamp', inplace=True)
        df_merged.ffill(inplace=True)
        df_merged.bfill(inplace=True)

        df_merged['timestamp_sec'] = df_merged['timestamp'] / 1E6
        
        print("    -> Successfully processed accel vibration metrics.")

        return df_merged[['timestamp_sec', 'accel0_vibration', 'accel1_vibration', 'accel2_vibration']]

    except Exception as e:
        print(f"  - Error calculating accel vibration metrics: {e}")
        return None

def calculate_magnetometer_norm(ulog_object):
    try:
        topic_data = next(d for d in ulog_object.data_list if d.name == 'vehicle_magnetometer' and d.multi_id == 0)
        df = pd.DataFrame(topic_data.data)

        df['timestamp_sec'] = df['timestamp'] / 1E6

        df['norm_magnetometer'] = np.sqrt(
            df['magnetometer_ga[0]']**2 +
            df['magnetometer_ga[1]']**2 +
            df['magnetometer_ga[2]']**2
        )
        
        print("    -> Successfully calculated magnetometer norm.")

        return df[['timestamp_sec', 'norm_magnetometer', 'magnetometer_ga[0]', 'magnetometer_ga[1]', 'magnetometer_ga[2]']]

    except Exception as e:
        print(f"  - Error calculating magnetometer norm: {e}")
        return None

def analyze_sensor_temperature(ulog_object):
    try:
        all_dfs = []
        for i in range(3):
            topic_data = next(d for d in ulog_object.data_list if d.name == 'sensor_accel' and d.multi_id == i)
            temp_df = pd.DataFrame(topic_data.data)[['timestamp', 'temperature']]
            temp_df.rename(columns={'temperature': f'temp_{i}'}, inplace=True)
            all_dfs.append(temp_df)
            
        if not all_dfs:
            raise Exception("No valid sensor_accel topics found.")

        df_merged = all_dfs[0]
        for i in range(1, len(all_dfs)):
            df_merged = pd.merge(df_merged, all_dfs[i], on='timestamp', how='outer')
        
        df_merged.sort_values(by='timestamp', inplace=True)
        df_merged.ffill(inplace=True)
        df_merged.bfill(inplace=True)

        temp_columns = [col for col in df_merged.columns if 'temp_' in col]
        df_merged['mean_temperature'] = df_merged[temp_columns].mean(axis=1)

        df_merged['timestamp_sec'] = df_merged['timestamp'] / 1E6
        
        print("    -> Successfully processed and averaged available sensor temperatures.")

        return df_merged[['timestamp_sec', 'mean_temperature']]

    except Exception as e:
        print(f"  - Error calculating mean sensor temperature: {e}")
        return None

# Need to check
def calculate_fft_from_series(df, time_col, data_col):
    if df is None or data_col not in df.columns or time_col not in df.columns:
        return np.array([]), np.array([])
        
    signal_df = df[[time_col, data_col]].dropna().copy()
    
    signal_df[data_col] = pd.to_numeric(signal_df[data_col], errors='coerce')
    signal_df.dropna(inplace=True)

    if len(signal_df) < 2:
        return np.array([]), np.array([])

    sampling_period = signal_df[time_col].diff().mean()
    if pd.isna(sampling_period) or sampling_period <= 0:
        return np.array([]), np.array([])

    N = len(signal_df[data_col])
    yf = rfft(signal_df[data_col].values)
    xf = rfftfreq(N, sampling_period)

    amplitude = (2.0 / N) * np.abs(yf)
    
    return xf, amplitude

# Need to check
def calculate_combined_psd(series_dfs):
    if not series_dfs:
        return None, None, None

    combined_df = pd.concat(series_dfs, axis=1, join='outer').interpolate(method='linear').dropna()

    if len(combined_df) < 256:
        return None, None, None

    sampling_rate = 1.0 / combined_df.index.to_series().diff().mean()
    if pd.isna(sampling_rate) or sampling_rate <= 0:
        return None, None, None

    sxx_squared_list = []
    final_times = None
    final_freqs = None

    for col in combined_df.columns:
        freqs, times, Sxx = signal.spectrogram(combined_df[col], fs=sampling_rate, nperseg=256, noverlap=128)
        sxx_squared_list.append(Sxx**2)
        if final_times is None: final_times = times
        if final_freqs is None: final_freqs = freqs
    
    if not sxx_squared_list:
        return None, None, None

    Sxx_magnitude = np.sqrt(sum(sxx_squared_list))
    Sxx_db = 10 * np.log10(Sxx_magnitude, where=Sxx_magnitude > 0, out=np.full_like(Sxx_magnitude, -100))
    
    start_time = combined_df.index[0]
    times_abs = final_times + start_time
    
    return final_freqs, times_abs, Sxx_db

def analyze_log(ulog_object, config):
    all_plots_data = {}
    print("--- Starting Log Analysis ---")
    
    processed_dfs = {}

    processed_dfs['vehicle_attitude'] = process_attitude_topic(ulog_object, 'vehicle_attitude')
    processed_dfs['vehicle_attitude_setpoint'] = process_attitude_topic(ulog_object, 'vehicle_attitude_setpoint')
    processed_dfs['actuator_outputs'] = calculate_abstract_controls_from_outputs(ulog_object)
    processed_dfs['vehicle_imu_status'] = accel_vibration_metrics(ulog_object)
    processed_dfs['vehicle_magnetometer'] = calculate_magnetometer_norm(ulog_object)
    processed_dfs['sensor_accel'] = analyze_sensor_temperature(ulog_object)
    try:
        sc_data = next(d for d in ulog_object.data_list if d.name == 'sensor_combined')
        df_sc = pd.DataFrame(sc_data.data)
        df_sc['timestamp_sec'] = df_sc['timestamp'] / 1E6
        df_sc['delta_t'] = df_sc['timestamp'].diff()
        processed_dfs['sensor_combined'] = df_sc
    except Exception as e:
        print(f"  - Warning: Could not process 'sensor_combined'. {e}")
        processed_dfs['sensor_combined'] = None

    for plot_key, plot_info in config.items():
        plot_series_data = {}
        print(f"\n* Processing plot: {plot_info['title']}")
        is_fft_plot = plot_info.get("setpoint_style") == "fft"
        is_psd_plot = plot_info.get("setpoint_style") == "psd"
        should_convert = plot_info.get("convert_rad_to_deg", False)

        for series_name, (topic, field) in plot_info['series'].items():
            try:
                if topic in processed_dfs and processed_dfs[topic] is not None:
                    df = processed_dfs[topic]
                else:
                    topic_data = next(d for d in ulog_object.data_list if d.name == topic)
                    df = pd.DataFrame(topic_data.data)
                    processed_dfs[topic] = df
                
                if 'timestamp_sec' not in df.columns:
                    df['timestamp_sec'] = df['timestamp'] / 1E6

                if is_fft_plot:
                    source_field = ""
                    if topic == "actuator_outputs":
                        source_field = field.replace('_fft', '_calc')
                    elif topic == "vehicle_angular_velocity":
                        axis_map = {'rollrate': 'xyz[0]', 'pitchrate': 'xyz[1]', 'yawrate': 'xyz[2]'}
                        source_field = axis_map.get(field.replace('_fft', ''))
                    
                    if not source_field or source_field not in df.columns:
                         print(f"  - Warning: Could not determine source for FFT field '{field}'.")
                         plot_series_data[series_name] = {"points": [], "stats": {}}
                         continue
                    
                    freq, ampl = calculate_fft_from_series(df, 'timestamp_sec', source_field)
                    data_points = list(zip(freq, ampl))
                    plot_series_data[series_name] = {"points": data_points, "stats": {}}
                    print(f"  + Successfully calculated FFT for: {series_name} from {source_field}")
                elif is_psd_plot:
                    series_to_process = []
                    for series_name, (topic, field) in plot_info['series'].items():
                        df['timestamp_sec'] = df['timestamp'] / 1E6
                        if df is not None and field in df.columns:
                            series_to_process.append(df[['timestamp_sec', field]].copy().set_index('timestamp_sec'))
                    
                    frequencies, times, psd_data = calculate_combined_psd(series_to_process)

                    if frequencies is not None:
                        plot_series_data['combined'] = {
                            "frequencies": frequencies,
                            "times": times,
                            "psd_data": psd_data
                        }
                        print(f"  + Successfully calculated combined PSD for: {plot_key}")
                else:
                    series_df = df[['timestamp_sec', field]].copy().dropna()
                    
                    if topic == 'manual_control_switches' and field == 'mode_slot':
                        series_df[field] = series_df[field] / 6.0
                        print(f"    -> Scaled {series_name} by a factor of 6.")

                    if should_convert:
                        series_df[field] = np.rad2deg(series_df[field])
                        print(f"    -> Converted {series_name} from rad/s to deg/s.")

                    data_points = series_df.values.tolist()
                    stats = calculate_statistics(data_points)
                    plot_series_data[series_name] = {"points": data_points, "stats": stats}
                    print(f"  + Successfully extracted: {series_name}")

            except (StopIteration, KeyError):
                print(f"  - Warning: Could not find topic '{topic}' or field '{field}'.")
                plot_series_data[series_name] = {"points": [], "stats": {}}
        all_plots_data[plot_key] = plot_series_data
    return all_plots_data

def generate_interactive_plot_html(ylabel, plot_data, plot_config):
    fig = go.Figure()
    
    setpoint_style = plot_config.get("setpoint_style", "line")
    
    if setpoint_style == 'fft':
        min_freq = float('inf')
        max_freq = float('-inf')
        
        for series_name, series_data in plot_data.items():
            data_points = series_data.get("points", [])
            if not data_points:
                continue
            frequency, amplitude = zip(*data_points)
            if frequency:
                min_freq = min(min_freq, min(frequency))
                max_freq = max(max_freq, max(frequency))
            fig.add_trace(go.Scatter(x=frequency, y=amplitude, mode='lines', name=series_name))
        
        final_x_range = None
        if max_freq != float('-inf'):
            padding = max_freq * 0.02
            final_x_range = [-padding, max_freq + padding]
        
        fig.update_layout(
            xaxis_title="Frequency (Hz)", 
            yaxis_title="Amplitude",
            xaxis=dict(range=final_x_range)
        )
    elif setpoint_style == 'psd':
        psd_data = plot_data.get('combined')
        if psd_data:
            fig.add_trace(go.Heatmap(
                x=psd_data['times'],
                y=psd_data['frequencies'],
                z=psd_data['psd_data'],
                colorscale='Viridis',
                colorbar=dict(title='[dB]'),
                zmin=-50,
                zmax=10
            ))
        fig.update_layout(
            xaxis_title="(sec)",
            yaxis_title="(Hz)",
            yaxis=dict(range=[0, 100]),
        )
    else:
        min_time = float('inf')
        max_time = float('-inf')
        
        for series_name, series_data in plot_data.items():
            data_points = series_data.get("points", [])
            if not data_points:
                continue
            
            timestamps, values = zip(*data_points)
            if not timestamps: continue
            min_time = min(min_time, timestamps[0])
            max_time = max(max_time, timestamps[-1])

            if "Setpoint" in series_name:
                if setpoint_style == 'marker':
                    fig.add_trace(go.Scatter(x=timestamps, y=values, mode='markers', name=series_name, marker=dict(size=3)))
                elif setpoint_style == 'step':
                    fig.add_trace(go.Scatter(x=timestamps, y=values, mode='lines', name=series_name, line_shape='hv'))
                else:
                    fig.add_trace(go.Scatter(x=timestamps, y=values, mode='lines', name=series_name))
            else:
                fig.add_trace(go.Scatter(x=timestamps, y=values, mode='lines', name=series_name))

        final_x_range = None
        if min_time != float('inf') and max_time != float('-inf'):
            duration = max_time - min_time
            if duration > 0:
                padding = duration * 0.01
                final_x_range = [min_time - padding, max_time + padding]
        
        fig.update_layout(xaxis_title="(sec)", yaxis_title=ylabel, xaxis=dict(range=final_x_range))

    fig.update_layout(
        showlegend=True,
        dragmode='pan',
        margin=dict(l=20, r=20, t=20, b=20),
        legend=dict(yanchor="top", y=0.99, xanchor="right", x=0.99, bgcolor="rgba(255,255,255,0.75)", bordercolor="Black", borderwidth=1)
    )
    config = {'scrollZoom': True, 'displaylogo': False, 'responsive': True}
    return fig.to_html(full_html=False, include_plotlyjs='cdn', config=config)

def main():
    if len(sys.argv) < 2:
        print("Error: No log file path provided.")
        sys.exit(1)
    
    log_file_path = sys.argv[1]
    
    print(f"Processing log file: {log_file_path}")
    
    try:
        ulog = ULog(log_file_path)
    except Exception as e:
        print(f"Error processing ULog file: {e}")
        sys.exit(1)
        
    all_data = analyze_log(ulog, PLOTS_CONFIG)

    print("\n--- Generating Interactive HTML Report ---")
    log_basename = os.path.basename(log_file_path)
    
    html_parts = [f"""
    <html>
    <head>
        <title>Flight Review</title>
        <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
        <style>
            body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; margin: 2em; color: #333; }}
            h1 {{ color: #2c3e50; padding-bottom: 10px;}}
            h2 {{ color: #2c3e50; margin-bottom: 20px;}}
            h3 {{ color: #34495e; margin-top: 0; padding-bottom: 5px;}}
            .report-container {{ max-width: 95%; margin: auto; }}
            .plot-section {{ border-top: 3px solid #3498db; padding-top: 25px; margin-top: 40px; }}
            .flex-container {{ display: flex; flex-direction: row; align-items: flex-start; gap: 30px; flex-wrap: wrap; }}
            .info-column {{ flex-shrink: 0; width: 400px; }}
            .plot-column {{ flex: 1; min-width: 400px; }}
            table {{ border-collapse: collapse; width: 100%; box-shadow: 0 2px 3px rgba(0,0,0,0.1); }}
            th, td {{ border: 1px solid #dfe6e9; padding: 10px 12px; text-align: left; }}
            th {{ background-color: #f8f9fa; }}
            tr:nth-child(even) {{ background-color: #f9f9f9; }}
            .results-container {{ margin-top: 25px; padding: 15px; background-color: #fdfdfd; border: 1px solid #e0e0e0; border-radius: 5px; overflow-wrap: break-word; }}
            .results-container h3 {{ border-bottom: none; }}
            
            /* CSS mới để xếp chồng các mục trong biểu đồ FFT/PSD */
            .flex-container.vertical {{
                flex-direction: column;
            }}
            .flex-container.vertical .info-column,
            .flex-container.vertical .plot-column {{
                width: 100%;
            }}
        </style>
    </head>
    <body>
        <div class="report-container">
            <h1>Interactive Flight Log Analysis Report</h1>
    """]

    for plot_key, plot_data in all_data.items():
        plot_config = PLOTS_CONFIG[plot_key]
        plot_title = plot_config['title']
        plot_ylabel = plot_config.get('ylabel', 'Value')
        
        html_parts.append(f'<div class="plot-section"><h2>{plot_title}</h2>')
        
        plot_style = plot_config.get("setpoint_style", "line")
        container_class = "vertical" if plot_style in ["fft", "psd"] else ""
        html_parts.append(f'<div class="flex-container {container_class}">')

        html_parts.append('<div class="info-column">')
        if plot_style not in ["fft", "psd"]:
            html_parts.append("<h3>Statistics</h3>")
            html_parts.append("<table><tr><th>Series Name</th><th>Mean</th><th>Max</th><th>Min</th><th>Std Dev</th></tr>")
            for series_name, series_data in plot_data.items():
                stats = series_data.get("stats", {})
                mean_val, max_val, min_val, std_dev_val = stats.get('Mean'), stats.get('Max'), stats.get('Min'), stats.get('Std Dev')
                mean_str = f"{mean_val:.2f}" if isinstance(mean_val, (int, float)) else "N/A"
                max_str = f"{max_val:.2f}" if isinstance(max_val, (int, float)) else "N/A"
                min_str = f"{min_val:.2f}" if isinstance(min_val, (int, float)) else "N/A"
                std_dev_str = f"{std_dev_val:.2f}" if isinstance(std_dev_val, (int, float)) else "N/A"
                html_parts.append(f"<tr><td>{series_name}</td><td>{mean_str}</td><td>{max_str}</td><td>{min_str}</td><td>{std_dev_str}</td></tr>")
            html_parts.append("</table>")
        
        html_parts.append("<div class='results-container'><h3>Results</h3><p>Doesn't Analyze Yet!</p></div>")
        html_parts.append('</div>')

        html_parts.append('<div class="plot-column">')
        plot_html_div = generate_interactive_plot_html(plot_ylabel, plot_data, plot_config)
        html_parts.append(plot_html_div)
        html_parts.append('</div>')

        html_parts.append('</div></div>')

    html_parts.append("</div></body></html>")
    
    base_path = os.path.splitext(log_file_path)[0]
    base_path_cleaned = re.sub(r'log_\d+_', 'log_', base_path)
    report_filename = base_path_cleaned + ".html"
    with open(report_filename, 'w', encoding='utf-8') as f:
        f.write("\n".join(html_parts))
        
    print(f"\nReport generation complete. Please open the following file in your browser:")
    print(f"==> {os.path.abspath(report_filename)}")

if __name__ == "__main__":
    main()