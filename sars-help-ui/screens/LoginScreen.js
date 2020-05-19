import React from 'react';
import { StyleSheet, View, TextInput, TouchableOpacity } from 'react-native';
import { Icon, Text, Input } from 'react-native-elements';
import { makeStyles } from '@material-ui/core/styles';
import Avatar from '@material-ui/core/Avatar';
import Card from '@material-ui/core/Card';
import CardActions from '@material-ui/core/CardActions';
import CardContent from '@material-ui/core/CardContent';
import CardHeader from '@material-ui/core/CardHeader';
import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';
import FormControl from '@material-ui/core/FormControl';
import * as Yup from 'yup';

import Typography from '@material-ui/core/Typography';
import { Formik, Form, Field, ErrorMessage, useFormik } from 'formik';

export default class LoginScreen extends React.Component {
  emailInput = null;
  passwordInput = null;
  dniInput = null;
  render() {
      return (
          <View style={styles.container}>
            <Text style={styles.logo}>Help App</Text>
            <Card style={{width: '40%'}}>
              <CardHeader title="Iniciar sesión"/>
              <CardContent style={{flex: 1, flexDirection: 'column'}}>
                <Formik
                  initialValues={{ dni: '', email: '', password: '' }}
                  validationSchema={Yup.object({
                    dni: Yup.string()              
                      .required('Rut es requerido'),
                    email: Yup.string()
                      .email('Email inválido')
                      .required('Requerido'),
                    password: Yup.string()
                      .required('Required')
                      .min(4, 'Al menos debe tener 4 caracteres')
                  })}
                  onSubmit={(values, formikActions) => {
                    setTimeout(() => {
                      Alert.alert(JSON.stringify(values));
                      // Important: Make sure to setSubmitting to false so our loading indicator
                      // goes away.
                      formikActions.setSubmitting(false);
                    }, 500);
                  }}>
                  {props => ( console.log(props) ||
                    <View>
                      <View style={styles.containermat}>
                        <TextField
                            onChange={props.handleChange('dni')}
                            onBlur={props.handleBlur('dni')}
                            value={props.values.dni}
                            autoFocus
                            label="Rut"
                            placeholder="9.999.999-8"
                            variant="outlined"                          
                            error={props.touched.dni && props.errors.dni ? true : false}

                          />
                           {props.touched.dni && props.errors.dni ? (
                          <Text style={styles.error}>{props.errors.dni}</Text>
                        ) : null}
                      </View>
                      <View style={styles.containermat}>
                        <TextField
                          onChange={props.handleChange('email')}
                          onBlur={props.handleBlur('email')}
                          value={props.values.email}
                          label="Correo o usuario"
                          variant="outlined" 
                          id="username"
                          type="email"
                          error={props.touched.email && props.errors.email ? true : false}
                          placeholder="Email..."
                          ref={el => this.emailInput = el}
                        />
                        {props.touched.email && props.errors.email ? (
                          <Text style={styles.error}>{props.errors.email}</Text>
                        ) : null}
                      </View>
                      <View style={styles.containermat}>
                        <TextField
                          onChange={props.handleChange('password')}
                          onBlur={props.handleBlur('password')}
                          value={props.values.password}
                          label="Contraseña"
                          variant="outlined" 
                          id="password"
                          error={props.touched.password && props.errors.password ? true : false}
                          type="password"
                          placeholder="..."
                          ref={el => this.passwordInput = el}
                        />
                        {props.touched.password && props.errors.password ? (
                          <Text style={styles.error}>{props.errors.password}</Text>
                        ) : null}
                      </View>
                      <Button
                        onClick={props.handleSubmit}
                        mode="contained"
                        disabled={props.isSubmitting}
                        style={{ marginTop: 16 }}>
                        Submit
                      </Button>
                      <Button
                        onClick={props.handleReset}
                        mode="outlined"
                        disabled={props.isSubmitting}
                        style={{ marginTop: 16 }}>
                        Reset
                      </Button>
                    </View>
                  )}
                </Formik>
              </CardContent>
            </Card>
          </View>
      );
  }
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  error:{
    color: '#ff0000'
  }, 
    containermat:{
      padding: 24
    },
    logo:{
      fontWeight:"bold",
      fontSize:50,
      color:"#fb5b5a",
      marginBottom:40
    },
    inputView:{
      width:"80%",
      backgroundColor:"#465881",
      borderRadius:25,
      height:50,
      marginBottom:20,
      justifyContent:"center",
      padding:20
    },
    inputText:{
      height:50,
      color:"white"
    },
    forgot:{
      color:"white",
      fontSize:11
    },
    loginBtn:{
      width:"80%",
      backgroundColor:"#fb5b5a",
      borderRadius:25,
      height:50,
      alignItems:"center",
      justifyContent:"center",
      marginTop:40,
      marginBottom:10
    },
    loginText:{
      color:"white"
    }
  });
