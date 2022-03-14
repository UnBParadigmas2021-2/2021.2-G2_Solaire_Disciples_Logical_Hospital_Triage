import React from "react";
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell, { tableCellClasses } from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';

const PatientsTable = ({list, width="auto", height="auto"}) => {
   
   return (
      <TableContainer sx={{ maxWidth: 500}} component={Paper}>
         {list.length > 0 && (
            <Table aria-label="customized table">
               <TableHead>
                  <TableRow>
                     <TableCell>Hora da chegada</TableCell>
                     <TableCell>Nome</TableCell>
                     <TableCell>Prioridade Manchester</TableCell>
                     <TableCell>Prioridade Relativa</TableCell>
                  </TableRow>
               </TableHead>
               <TableBody>
                  {Object.values(list).map((obj, index) => (
                     <TableRow key={index}>
                           <TableCell align='right'>{new Date(obj.arrival_time * 1000).toLocaleString('pt-BR')}</TableCell>
                           <TableCell align='right'>{obj.nome}</TableCell>
                           <TableCell align='right'>{obj.manchester_priority}</TableCell>
                           <TableCell align='right'>{obj.relative_priority}</TableCell>
                              
                     </TableRow>
                  ))}
               </TableBody>
            </Table>
         )}
      </TableContainer>
   )
}

export default PatientsTable;